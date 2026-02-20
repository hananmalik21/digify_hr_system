import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_search_and_actions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_org_unit_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/org_unit_details_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/org_units_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DivisionValuesView extends ConsumerStatefulWidget {
  const DivisionValuesView({super.key});

  @override
  ConsumerState<DivisionValuesView> createState() => _DivisionValuesViewState();
}

class _DivisionValuesViewState extends ConsumerState<DivisionValuesView> {
  static const String _levelCode = 'DIVISION';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadOrgUnits());
  }

  void _maybeLoadOrgUnits() {
    final orgState = ref.read(orgUnitsProvider(_levelCode));
    if (orgState.isLoading || orgState.hasError || orgState.units.isNotEmpty || orgState.levelCode != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(manageComponentValuesScreenProvider.notifier).initializeLevel(_levelCode);
    });
  }

  void _handleSearchChanged(String value) {
    ref.read(manageComponentValuesScreenProvider.notifier).handleSearch(_levelCode, value);
  }

  void _handleAddNew() {
    final activeLevels = ref.read(activeLevelsProvider);
    if (activeLevels.levels.isEmpty) {
      ToastService.error(context, 'No active levels available');
      return;
    }
    final level = activeLevels.levels.firstWhere(
      (l) => l.levelCode == _levelCode,
      orElse: () => activeLevels.levels.first,
    );
    AddOrgUnitDialog.show(context, structureId: level.structureId, levelCode: _levelCode);
  }

  void _handleEdit(OrgStructureLevel unit) {
    final activeLevels = ref.read(activeLevelsProvider);
    final level = activeLevels.levels.firstWhere(
      (l) => l.levelCode == _levelCode,
      orElse: () => activeLevels.levels.first,
    );
    AddOrgUnitDialog.show(context, structureId: level.structureId, levelCode: _levelCode, initialValue: unit);
  }

  Future<void> _handleDelete(OrgStructureLevel unit) async {
    final localizations = AppLocalizations.of(context)!;
    final activeLevels = ref.read(activeLevelsProvider);
    final level = activeLevels.levels.firstWhere(
      (l) => l.levelCode == _levelCode,
      orElse: () => activeLevels.levels.first,
    );
    var isLoading = false;
    await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return DeleteConfirmationDialog(
            title: localizations.delete,
            message: 'Are you sure you want to delete this ${_levelCode.toLowerCase()}? This action cannot be undone.',
            itemName: unit.orgUnitNameEn,
            isLoading: isLoading,
            onConfirm: () async {
              setState(() => isLoading = true);
              try {
                final deleteUseCase = ref.read(deleteOrgUnitUseCaseProvider);
                await deleteUseCase.call(level.structureId, unit.orgUnitId, hard: true);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(true);
                  ToastService.success(dialogContext, '${unit.orgUnitNameEn} deleted successfully');
                  ref.read(orgUnitsProvider(_levelCode).notifier).refresh();
                }
              } catch (e) {
                setState(() => isLoading = false);
                if (dialogContext.mounted) {
                  ToastService.error(dialogContext, 'Failed to delete: ${e.toString()}');
                }
              }
            },
            onCancel: () {
              if (!isLoading) Navigator.of(dialogContext).pop(false);
            },
          );
        },
      ),
    );
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
          searchHint: 'Search divisions...',
          searchValue: screenState.orgUnitsSearchQuery,
          onSearchChanged: _handleSearchChanged,
          addNewLabel: 'Add New',
          bulkUploadLabel: localizations.bulkUpload,
          exportLabel: localizations.export,
          onAddNew: _handleAddNew,
          onBulkUpload: () {},
          onExport: () {},
        ),
        Gap(24.h),
        if (orgUnitsState.hasError)
          _buildErrorView(orgUnitsState.errorMessage, isDark)
        else ...[
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
            onEdit: _handleEdit,
            onDelete: _handleDelete,
          ),
        ],
      ],
    );
  }

  Widget _buildErrorView(String? errorMessage, bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage ?? 'Failed to load divisions',
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
