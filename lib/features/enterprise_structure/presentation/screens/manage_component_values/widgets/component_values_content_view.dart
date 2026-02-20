import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/org_units_table_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/org_units_tree_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_pagination.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_table_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/component_detail_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/create_component_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesContentView extends ConsumerStatefulWidget {
  const ComponentValuesContentView({
    super.key,
    required this.selectedLevelCode,
    required this.componentValuesState,
    required this.isDark,
    required this.localizations,
    required this.onOrgUnitView,
    required this.onOrgUnitEdit,
    required this.onOrgUnitDelete,
  });

  final String? selectedLevelCode;
  final ComponentValuesState componentValuesState;
  final bool isDark;
  final AppLocalizations localizations;
  final void Function(OrgStructureLevel unit) onOrgUnitView;
  final void Function(OrgStructureLevel unit) onOrgUnitEdit;
  final void Function(OrgStructureLevel unit) onOrgUnitDelete;

  @override
  ConsumerState<ComponentValuesContentView> createState() => _ComponentValuesContentViewState();
}

class _ComponentValuesContentViewState extends ConsumerState<ComponentValuesContentView> {
  @override
  Widget build(BuildContext context) {
    final state = widget.componentValuesState;
    final selectedLevelCode = widget.selectedLevelCode;

    if (state.isTreeView && selectedLevelCode == null) {
      return OrgUnitsTreeWidget(localizations: widget.localizations, isDark: widget.isDark);
    }

    if (selectedLevelCode != null && selectedLevelCode.isNotEmpty) {
      return _OrgUnitsTableSection(
        levelCode: selectedLevelCode,
        isDark: widget.isDark,
        localizations: widget.localizations,
        onView: widget.onOrgUnitView,
        onEdit: widget.onOrgUnitEdit,
        onDelete: widget.onOrgUnitDelete,
      );
    }

    return _ComponentTableSection(state: state, isDark: widget.isDark, localizations: widget.localizations);
  }
}

class _OrgUnitsTableSection extends ConsumerStatefulWidget {
  const _OrgUnitsTableSection({
    required this.levelCode,
    required this.isDark,
    required this.localizations,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final String levelCode;
  final bool isDark;
  final AppLocalizations localizations;
  final void Function(OrgStructureLevel) onView;
  final void Function(OrgStructureLevel) onEdit;
  final void Function(OrgStructureLevel) onDelete;

  @override
  ConsumerState<_OrgUnitsTableSection> createState() => _OrgUnitsTableSectionState();
}

class _OrgUnitsTableSectionState extends ConsumerState<_OrgUnitsTableSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadOrgUnits());
  }

  @override
  void didUpdateWidget(_OrgUnitsTableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.levelCode != widget.levelCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadOrgUnits());
    }
  }

  void _maybeLoadOrgUnits() {
    final orgState = ref.read(orgUnitsProvider(widget.levelCode));
    if (orgState.isLoading || orgState.hasError || orgState.units.isNotEmpty || orgState.levelCode != null) return;
    final activeLevels = ref.read(activeLevelsProvider);
    final level = activeLevels.levels.firstWhere(
      (l) => l.levelCode == widget.levelCode,
      orElse: () => activeLevels.levels.first,
    );
    ref
        .read(orgUnitsProvider(widget.levelCode).notifier)
        .loadOrgUnits(widget.levelCode, structureId: level.structureId, page: 1, pageSize: 10);
  }

  @override
  Widget build(BuildContext context) {
    final orgUnitsState = ref.watch(orgUnitsProvider(widget.levelCode));

    if (orgUnitsState.hasError) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                orgUnitsState.errorMessage ?? 'Failed to load org units',
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
              ),
              Gap(16.h),
              ElevatedButton(
                onPressed: () => ref.read(orgUnitsProvider(widget.levelCode).notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        OrgUnitsTableWidget(
          units: orgUnitsState.units,
          isLoading: orgUnitsState.isLoading,
          isDark: widget.isDark,
          localizations: widget.localizations,
          onView: widget.onView,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
        ),
        if (orgUnitsState.totalItems > 0) ...[
          Gap(24.h),
          ComponentValuesPagination(levelCode: widget.levelCode, orgUnitsState: orgUnitsState, isDark: widget.isDark),
        ],
      ],
    );
  }
}

class _ComponentTableSection extends ConsumerWidget {
  const _ComponentTableSection({required this.state, required this.isDark, required this.localizations});

  final ComponentValuesState state;
  final bool isDark;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgStructuresState = ref.watch(orgStructuresDropdownProvider);
    return ComponentTableView(
      components: state.filteredComponents,
      allComponents: state.components,
      filterType: state.filterType,
      orgStructures: orgStructuresState.structures,
      onView: (component) {
        ComponentDetailDialog.show(context, component: component, allComponents: state.components);
      },
      onEdit: (component) {
        CreateComponentDialog.show(context, initialValue: component);
      },
      onDelete: (component) {},
      onDuplicate: state.filterType == ComponentType.department ? (component) {} : null,
    );
  }
}
