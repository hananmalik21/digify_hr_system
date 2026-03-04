import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/enterprise_structure_enums.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart'
    show manageComponentValuesActiveLevelsProvider;
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_enterprise_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_search_and_actions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/dialogs/org_unit_details_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_units_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Self-contained view that fetches and displays org units for a given level.
/// Each tab owns its own API calls - no orchestration from screen provider.
class LevelOrgUnitsView extends ConsumerStatefulWidget {
  const LevelOrgUnitsView({super.key, required this.level, required this.searchHint, this.levelCodeOverride});

  final OrganizationLevel level;
  final String searchHint;

  /// Use for OrganizationLevel.unknown when level code comes from API.
  final String? levelCodeOverride;

  @override
  ConsumerState<LevelOrgUnitsView> createState() => _LevelOrgUnitsViewState();
}

class _LevelOrgUnitsViewState extends ConsumerState<LevelOrgUnitsView> {
  String get _levelCode => widget.levelCodeOverride ?? widget.level.code;

  void _loadOrgUnits() {
    if (_levelCode.isEmpty) return;

    final enterpriseId = ref.read(manageComponentValuesEnterpriseIdProvider);
    if (enterpriseId == null) return;

    final activeLevels = ref.read(manageComponentValuesActiveLevelsProvider);
    if (activeLevels.levels.isEmpty) return;

    final activeLevel = activeLevels.levels.firstWhere(
      (l) => l.levelCode.toUpperCase() == _levelCode,
      orElse: () => activeLevels.levels.first,
    );

    ref
        .read(orgUnitsProvider(_levelCode).notifier)
        .loadOrgUnits(
          _levelCode,
          structureId: activeLevel.structureId,
          enterpriseId: enterpriseId,
          page: 1,
          pageSize: 10,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOrgUnits());
  }

  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(manageComponentValuesScreenProvider);
    final orgUnitsState = ref.watch(orgUnitsProvider(_levelCode));
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentValuesSearchAndActions(
          isDark: isDark,
          searchHint: widget.searchHint,
          searchValue: screenState.orgUnitsSearchQuery,
          onSearchChanged: (value) =>
              ref.read(manageComponentValuesScreenProvider.notifier).handleSearch(_levelCode, value),
          addNewLabel: 'Add New',
          bulkUploadLabel: localizations.bulkUpload,
          exportLabel: localizations.export,
          onAddNew: () => ref
              .read(manageComponentValuesScreenProvider.notifier)
              .handleAddOrgUnit(context, widget.level, levelCode: widget.levelCodeOverride),
          onBulkUpload: () {},
          onExport: () {},
        ),
        Gap(24.h),
        if (orgUnitsState.hasError)
          _buildErrorView(orgUnitsState.errorMessage, isDark)
        else
          OrgUnitsTableWidget(
            units: orgUnitsState.units,
            isLoading: orgUnitsState.isLoading,
            isDark: isDark,
            localizations: localizations,
            paginationInfo: orgUnitsState.pagination,
            currentPage: orgUnitsState.currentPage,
            pageSize: 10,
            onPrevious: orgUnitsState.pagination.hasPrevious
                ? () => ref.read(orgUnitsProvider(_levelCode).notifier).goToPage(orgUnitsState.currentPage - 1)
                : null,
            onNext: orgUnitsState.pagination.hasNext
                ? () => ref.read(orgUnitsProvider(_levelCode).notifier).goToPage(orgUnitsState.currentPage + 1)
                : null,
            onView: (unit) => OrgUnitDetailsDialog.show(context, unit),
            onEdit: (unit) => ref
                .read(manageComponentValuesScreenProvider.notifier)
                .handleEditOrgUnit(context, widget.level, unit, levelCode: widget.levelCodeOverride),
            onDelete: (unit) => _handleDelete(unit),
            deleteState: OrgUnitsDeleteState(deletingOrgUnitId: screenState.deletingOrgUnitId),
          ),
      ],
    );
  }

  Future<void> _handleDelete(OrgStructureLevel unit) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: AppLocalizations.of(context)!.delete,
      message: 'Are you sure you want to delete this ${_levelCode.toLowerCase()}? This action cannot be undone.',
      itemName: unit.orgUnitNameEn,
    );

    if (confirmed == true && mounted) {
      await ref
          .read(manageComponentValuesScreenProvider.notifier)
          .deleteOrgUnit(context, widget.level, unit, levelCode: widget.levelCodeOverride);
    }
  }

  Widget _buildErrorView(String? errorMessage, bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage ?? 'Failed to load',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
            Gap(16.h),
            ElevatedButton(
              onPressed: () => ref.read(orgUnitsProvider(_levelCode).notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
