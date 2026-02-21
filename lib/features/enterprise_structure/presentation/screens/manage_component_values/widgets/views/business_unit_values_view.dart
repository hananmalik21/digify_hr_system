import 'package:digify_hr_system/core/enums/enterprise_structure_enums.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_search_and_actions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/org_unit_details_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/org_units_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BusinessUnitValuesView extends ConsumerStatefulWidget {
  const BusinessUnitValuesView({super.key});

  @override
  ConsumerState<BusinessUnitValuesView> createState() => _BusinessUnitValuesViewState();
}

class _BusinessUnitValuesViewState extends ConsumerState<BusinessUnitValuesView> {
  static const OrganizationLevel _level = OrganizationLevel.businessUnit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(manageComponentValuesScreenProvider.notifier).initializeLevel(_level);
    });
  }

  void _handleSearchChanged(String value) {
    ref.read(manageComponentValuesScreenProvider.notifier).handleSearch(_level.code, value);
  }

  void _handleAddNew() {
    ref.read(manageComponentValuesScreenProvider.notifier).handleAddOrgUnit(context, _level);
  }

  void _handleEdit(OrgStructureLevel unit) {
    ref.read(manageComponentValuesScreenProvider.notifier).handleEditOrgUnit(context, _level, unit);
  }

  Future<void> _handleDelete(OrgStructureLevel unit) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: AppLocalizations.of(context)!.delete,
      message: 'Are you sure you want to delete this ${_level.code.toLowerCase()}? This action cannot be undone.',
      itemName: unit.orgUnitNameEn,
    );

    if (confirmed == true && mounted) {
      await ref.read(manageComponentValuesScreenProvider.notifier).deleteOrgUnit(context, _level, unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenState = ref.watch(manageComponentValuesScreenProvider);
    final orgUnitsState = ref.watch(orgUnitsProvider(_level.code));
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentValuesSearchAndActions(
          isDark: isDark,
          searchHint: 'Search business units...',
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
                ? () => ref.read(orgUnitsProvider(_level.code).notifier).goToPage(orgUnitsState.currentPage - 1)
                : null,
            onNext: orgUnitsState.pagination.hasNext
                ? () => ref.read(orgUnitsProvider(_level.code).notifier).goToPage(orgUnitsState.currentPage + 1)
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
              errorMessage ?? 'Failed to load business units',
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
            Gap(16.h),
            ElevatedButton(
              onPressed: () => ref.read(orgUnitsProvider(_level.code).notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
