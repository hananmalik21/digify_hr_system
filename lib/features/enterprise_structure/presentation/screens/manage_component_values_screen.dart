import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_content_view.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_level_tabs.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_search_and_actions.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_stat_cards.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_org_unit_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure_widgets/header_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/org_unit_details_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/bulk_upload_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/create_component_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ManageComponentValuesScreen extends ConsumerWidget {
  const ManageComponentValuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final cvState = ref.watch(componentValuesProvider);
    final screenState = ref.watch(manageComponentValuesScreenProvider);
    final screenNotifier = ref.read(manageComponentValuesScreenProvider.notifier);
    final selectedLevelCode = screenState.selectedLevelCode;

    final orgUnitsStateForRefresh = selectedLevelCode != null ? ref.watch(orgUnitsProvider(selectedLevelCode)) : null;
    final isRefreshingOrgUnits =
        orgUnitsStateForRefresh != null &&
        orgUnitsStateForRefresh.isLoading &&
        orgUnitsStateForRefresh.units.isNotEmpty;

    final statCards = buildStatCardsFromCounts(
      cvState.statCounts,
      companiesLabel: localizations.companies,
      divisionsLabel: localizations.divisions,
      businessUnitsLabel: localizations.businessUnits,
      departmentsLabel: localizations.departments,
      sectionsLabel: localizations.sections,
    );

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: EdgeInsetsDirectional.only(top: 16.h, start: 16.w, end: 16.w, bottom: 16.h),
                tablet: EdgeInsetsDirectional.only(top: 24.h, start: 24.w, end: 24.w, bottom: 24.h),
                web: EdgeInsetsDirectional.only(top: 24.h, start: 24.w, end: 24.w, bottom: 24.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    title: localizations.enterpriseStructure,
                    icon: Assets.icons.manageEnterpriseIcon.path,
                    localizations: localizations,
                  ),
                  Gap(24.h),
                  ComponentValuesStatCards(cards: statCards, isDark: isDark),
                  Gap(24.h),
                  ComponentValuesLevelTabs(
                    treeViewLabel: localizations.treeView,
                    isTreeViewActive: cvState.isTreeView,
                    selectedLevelCode: selectedLevelCode,
                    levels: ref.watch(activeLevelsProvider).levels,
                    isLevelsLoading: ref.watch(activeLevelsProvider).isLoading,
                    levelsError: ref.watch(activeLevelsProvider).errorMessage,
                    isDark: isDark,
                    onTreeViewTap: screenNotifier.selectTreeView,
                    onLevelTap: screenNotifier.selectLevel,
                  ),
                  if (!cvState.isTreeView || selectedLevelCode != null) ...[
                    Gap(24.h),
                    ComponentValuesSearchAndActions(
                      isDark: isDark,
                      searchHint: selectedLevelCode != null ? 'Search org units...' : localizations.searchComponents,
                      searchValue: selectedLevelCode != null ? screenState.orgUnitsSearchQuery : cvState.searchQuery,
                      onSearchChanged: (value) => _onSearchChanged(ref, selectedLevelCode, value),
                      addNewLabel: 'Add New',
                      bulkUploadLabel: localizations.bulkUpload,
                      exportLabel: localizations.export,
                      onAddNew: () => _onAddNew(context, ref, selectedLevelCode, cvState.filterType),
                      onBulkUpload: () => _onBulkUpload(context, selectedLevelCode),
                      onExport: () => _onExport(selectedLevelCode),
                    ),
                  ],
                  Gap(24.h),
                  if (cvState.isLoading && cvState.components.isEmpty && selectedLevelCode == null)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
                            Gap(16.h),
                            Text(
                              localizations.pleaseWait,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ComponentValuesContentView(
                      selectedLevelCode: selectedLevelCode,
                      componentValuesState: cvState,
                      isDark: isDark,
                      localizations: localizations,
                      onOrgUnitView: (unit) => OrgUnitDetailsDialog.show(context, unit),
                      onOrgUnitEdit: (unit) => _onOrgUnitEdit(context, ref, selectedLevelCode!, unit),
                      onOrgUnitDelete: (unit) =>
                          _onOrgUnitDelete(context, ref, selectedLevelCode!, unit, localizations),
                    ),
                ],
              ),
            ),
            if (isRefreshingOrgUnits)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppLoadingIndicator(type: LoadingType.fadingCircle, color: AppColors.primary),
                          Gap(16.h),
                          Text(
                            localizations.pleaseWait,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _onSearchChanged(WidgetRef ref, String? selectedLevelCode, String value) {
  if (selectedLevelCode != null) {
    ref.read(manageComponentValuesScreenProvider.notifier).setOrgUnitsSearchQuery(value);
    Future.delayed(const Duration(milliseconds: 500), () {
      ref.read(orgUnitsProvider(selectedLevelCode).notifier).search(value);
    });
  } else {
    ref.read(componentValuesProvider.notifier).searchComponents(value);
  }
}

void _onAddNew(BuildContext context, WidgetRef ref, String? selectedLevelCode, dynamic filterType) {
  if (selectedLevelCode != null) {
    final activeLevels = ref.read(activeLevelsProvider);
    if (activeLevels.levels.isEmpty) {
      ToastService.error(context, 'No active levels available');
      return;
    }
    final level = activeLevels.levels.firstWhere(
      (l) => l.levelCode == selectedLevelCode,
      orElse: () => activeLevels.levels.first,
    );
    AddOrgUnitDialog.show(context, structureId: level.structureId, levelCode: selectedLevelCode);
  } else {
    CreateComponentDialog.show(context, defaultType: filterType);
  }
}

void _onBulkUpload(BuildContext context, String? selectedLevelCode) {
  if (selectedLevelCode == null) {
    BulkUploadDialog.show(context);
  }
}

void _onExport(String? selectedLevelCode) {}

void _onOrgUnitEdit(BuildContext context, WidgetRef ref, String selectedLevelCode, OrgStructureLevel unit) {
  final activeLevels = ref.read(activeLevelsProvider);
  final level = activeLevels.levels.firstWhere(
    (l) => l.levelCode == selectedLevelCode,
    orElse: () => activeLevels.levels.first,
  );
  AddOrgUnitDialog.show(context, structureId: level.structureId, levelCode: selectedLevelCode, initialValue: unit);
}

Future<void> _onOrgUnitDelete(
  BuildContext context,
  WidgetRef ref,
  String selectedLevelCode,
  OrgStructureLevel unit,
  AppLocalizations localizations,
) async {
  final activeLevels = ref.read(activeLevelsProvider);
  final level = activeLevels.levels.firstWhere(
    (l) => l.levelCode == selectedLevelCode,
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
          message:
              'Are you sure you want to delete this ${selectedLevelCode.toLowerCase()}? This action cannot be undone.',
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
                ref.read(orgUnitsProvider(selectedLevelCode).notifier).refresh();
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
