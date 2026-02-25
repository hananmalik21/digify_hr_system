import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/timesheet_enums.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet_status.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_filter_org_param_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimesheetSearchAndFilter extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final TimesheetStatus? statusFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<TimesheetStatus?> onStatusFilterChanged;
  final bool isDark;

  const TimesheetSearchAndFilter({
    super.key,
    required this.searchController,
    required this.statusFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.isDark,
  });

  @override
  ConsumerState<TimesheetSearchAndFilter> createState() => _TimesheetSearchAndFilterState();
}

class _TimesheetSearchAndFilterState extends ConsumerState<TimesheetSearchAndFilter> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCompact)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyTextField.search(
                  controller: widget.searchController,
                  hintText: 'Search...',
                  onChanged: widget.onSearchChanged,
                ),
                Gap(12.h),
                SizedBox(
                  width: double.infinity,
                  child: DigifySelectField<TimesheetStatus?>(
                    hint: 'All Status',
                    value: widget.statusFilter,
                    items: timesheetStatusFilterItems,
                    itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                    onChanged: widget.onStatusFilterChanged,
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DigifyTextField.search(
                    controller: widget.searchController,
                    hintText: 'Search...',
                    onChanged: widget.onSearchChanged,
                  ),
                ),
                Gap(16.w),
                SizedBox(
                  width: 180.w,
                  child: DigifySelectField<TimesheetStatus?>(
                    hint: 'All Status',
                    value: widget.statusFilter,
                    items: timesheetStatusFilterItems,
                    itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                    onChanged: widget.onStatusFilterChanged,
                  ),
                ),
              ],
            ),
          Gap(16.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.outline(
              label: 'Filters',
              svgPath: Assets.icons.employeeManagement.filterMain.path,
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
          if (_showFilters) ...[
            Gap(16.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.backgroundDark : AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
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
                            assetPath: Assets.icons.employeeManagement.filterSecondary.path,
                            width: 20,
                            height: 20,
                          ),
                          Gap(8.w),
                          Text(
                            'Advanced Filters',
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _resetOrgFilters,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Reset filters',
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(color: AppColors.brandRed, fontWeight: FontWeight.w500),
                            ),
                            Gap(6.w),
                            DigifyAsset(
                              assetPath: Assets.icons.refreshGray.path,
                              width: 16.w,
                              height: 16.h,
                              color: AppColors.brandRed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(16.h),
                  Wrap(spacing: 14.w, runSpacing: 14.h, children: _buildOrgFilters(context)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildOrgFilters(BuildContext context) {
    final enterpriseId = ref.watch(timesheetEnterpriseIdProvider);
    final notifier = ref.read(timesheetNotifierProvider.notifier);

    if (enterpriseId == null) {
      return [
        Text(
          'Select an enterprise to use filters',
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            color: widget.isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
          ),
        ),
      ];
    }

    final param = ref.watch(timesheetFilterOrgParamProvider(enterpriseId));

    if (param == null) {
      final orgState = ref.watch(enterpriseOrgStructureNotifierProvider(enterpriseId));

      if (!orgState.isLoading && !orgState.hasAttemptedLoad) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(enterpriseOrgStructureNotifierProvider(enterpriseId).notifier)
              .fetchOrgStructureByEnterpriseId(enterpriseId);
        });
      }

      return _buildOrgFiltersLoadingPlaceholders();
    }

    return _buildOrgCascade(param, notifier);
  }

  List<Widget> _buildOrgFiltersLoadingPlaceholders() {
    return List.generate(4, (_) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: SizedBox(
          width: 180.w,
          height: 48.h,
          child: Skeletonizer(
            enabled: true,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: widget.isDark ? AppColors.inputBgDark : AppColors.inputBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: widget.isDark ? AppColors.cardBorderDark : AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 14.h,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                  Gap(8.w),
                  Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildOrgCascade(
    ({List<OrgStructureLevel> levels, String structureId}) param,
    TimesheetNotifier notifier,
  ) {
    final selectionProvider = enterpriseSelectionNotifierProvider(param);
    final selectionState = ref.watch(selectionProvider);
    final levels = param.levels;

    return levels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final isEnabled = index == 0 || selectionState.getSelection(levels[index - 1].levelCode) != null;

      return SizedBox(
        width: 180.w,
        child: DigifyStyleOrgLevelField(
          level: level,
          selectionProvider: selectionProvider,
          isEnabled: isEnabled,
          showLabel: false,
          onSelectionChanged: (levelCode, unit) {
            final id = unit?.orgUnitId;
            if (id == null) {
              return;
            }
            notifier.setOrgFilter(id.toString(), levelCode);
          },
        ),
      );
    }).toList();
  }

  void _resetOrgFilters() {
    final enterpriseId = ref.read(timesheetEnterpriseIdProvider);
    if (enterpriseId != null) {
      final param = ref.read(timesheetFilterOrgParamProvider(enterpriseId));
      if (param != null) {
        ref.read(enterpriseSelectionNotifierProvider(param).notifier).reset();
      }
    }

    final notifier = ref.read(timesheetNotifierProvider.notifier);
    notifier.setOrgFilter(null, null);
  }
}
