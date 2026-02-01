import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeSearchAndActions extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const EmployeeSearchAndActions({super.key, required this.localizations, required this.isDark});

  @override
  ConsumerState<EmployeeSearchAndActions> createState() => _EmployeeSearchAndActionsState();
}

class _EmployeeSearchAndActionsState extends ConsumerState<EmployeeSearchAndActions> {
  late final TextEditingController _searchController;
  String? _filterValue;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = widget.localizations;
    final isDark = widget.isDark;
    final showFilters = ref.watch(manageEmployeesShowFiltersProvider);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: localizations.typeToSearchEmployees,
            onChanged: (_) {},
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 144.w,
                child: DigifySelectField<String?>(
                  label: '',
                  hint: localizations.allStatus,
                  value: _filterValue,
                  items: [null],
                  itemLabelBuilder: (v) => localizations.allStatus,
                  onChanged: (value) {
                    setState(() => _filterValue = value);
                  },
                ),
              ),
              AppButton(
                label: localizations.filters,
                onPressed: () {
                  ref.read(manageEmployeesShowFiltersProvider.notifier).state = !showFilters;
                },
                svgPath: Assets.icons.leaveManagement.filter.path,
                backgroundColor: showFilters ? AppColors.primary.withValues(alpha: 0.15) : null,
              ),
              AppButton(
                label: localizations.export,
                onPressed: () {},
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
              AppButton(
                label: localizations.import,
                onPressed: () {},
                svgPath: Assets.icons.bulkUploadIconFigma.path,
                backgroundColor: AppColors.shiftUploadButton,
              ),
              AppButton(label: localizations.refresh, onPressed: () {}, svgPath: Assets.icons.refreshGray.path),
            ],
          ),
          if (showFilters) ...[
            Gap(16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.leaveManagement.filter.path,
                            width: 20,
                            height: 20,
                            color: AppColors.statIconPurple,
                          ),
                          Gap(8.w),
                          Text(
                            localizations.advancedFilters,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizations.clearAll,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                            ),
                            Gap(6.w),
                            DigifyAsset(
                              assetPath: Assets.icons.refreshGray.path,
                              width: 16,
                              height: 16,
                              color: AppColors.brandRed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(16.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _filterDropdown(context, localizations.allStatuses, 140.w),
                      _filterDropdown(context, localizations.allDepartments, 140.w),
                      _filterDropdown(context, localizations.allCompanies, 140.w),
                      _filterDropdown(context, localizations.allDivisions, 140.w),
                      _filterDropdown(context, localizations.allPositions, 140.w),
                      _filterDropdown(context, localizations.allWorkforceStructures, 160.w),
                      _filterDropdown(context, localizations.allJobFamilies, 140.w),
                      _filterDropdown(context, localizations.allJobLevels, 140.w),
                      _filterDropdown(context, localizations.allGrades, 120.w),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _filterDropdown(BuildContext context, String hint, double width) {
    return SizedBox(
      width: width,
      child: DigifySelectField<String?>(
        label: '',
        hint: hint,
        value: null,
        items: [null],
        itemLabelBuilder: (v) => hint,
        onChanged: (_) {},
      ),
    );
  }
}
