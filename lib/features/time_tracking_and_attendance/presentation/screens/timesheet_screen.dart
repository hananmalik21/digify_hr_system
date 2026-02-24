import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_pagination.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_stat_card.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/attendance/component_enterprise_filters_card.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet_status.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_dialog.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_table.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_week_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/assets/digify_asset.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/export_button.dart';
import '../../../../core/widgets/buttons/import_button.dart';
import '../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../gen/assets.gen.dart';

class TimesheetScreen extends ConsumerStatefulWidget {
  const TimesheetScreen({super.key});

  @override
  ConsumerState<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends ConsumerState<TimesheetScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(timesheetNotifierProvider);
    final notifier = ref.read(timesheetNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 27.w, right: 21.w, top: 61.h, bottom: 48.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                context.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeaderTitle(context, isDark),
                          Gap(16.h),
                          _buildHeaderActions(context.isMobile),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [_buildHeaderTitle(context, isDark), _buildHeaderActions(context.isMobile)],
                      ),
                Gap(21.h),

                // Week Navigation
                WeekNavigation(
                  weekStartDate: state.weekStartDate,
                  weekEndDate: state.weekEndDate,
                  onPreviousWeek: notifier.goToPreviousWeek,
                  onNextWeek: notifier.goToNextWeek,
                  onCurrentWeek: notifier.goToCurrentWeek,
                  isDark: isDark,
                ),
                Gap(21.h),

                // Statistics Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cards = [
                      AttendanceStatCard(
                        label: 'Total',
                        value: state.total.toString(),
                        iconPath: Assets.icons.viewIconBlueFigma.path,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                      AttendanceStatCard(
                        label: 'Draft',
                        value: state.draft.toString(),
                        iconPath: Assets.icons.headIcon.path,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                      AttendanceStatCard(
                        label: 'Submitted',
                        value: state.submitted.toString(),
                        iconPath: Assets.icons.submitted.path,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                      AttendanceStatCard(
                        label: 'Approved',
                        value: state.approved.toString(),
                        icon: Icons.check_circle_outline,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                      AttendanceStatCard(
                        label: 'Rejected',
                        value: state.rejected.toString(),
                        icon: Icons.cancel_outlined,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                      AttendanceStatCard(
                        label: 'Reg. Hours',
                        value: '${state.regularHours.toInt()}h',
                        iconPath: Assets.icons.clockIcon.path,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                      AttendanceStatCard(
                        label: 'OT Hours',
                        value: '${state.overtimeHours.toInt()}h',
                        iconPath: Assets.icons.attendance.halfDay.path,
                        iconBackgroundColor: AppColors.jobRoleBg,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                      ),
                    ];
                    final screenWidth = constraints.maxWidth;
                    final horizontalPadding = 48.w;
                    final spacing = 16.w;
                    final minWidth = 150.w;

                    final availableWidth = screenWidth - horizontalPadding;
                    final totalItems = cards.length;

                    int maxItemsPerRow = ((availableWidth + spacing) / (minWidth + spacing)).floor();
                    if (maxItemsPerRow < 1) maxItemsPerRow = 1;

                    final itemsInRow = totalItems < maxItemsPerRow ? totalItems : maxItemsPerRow;

                    final totalSpacing = (itemsInRow - 1) * spacing;
                    final itemWidth = (availableWidth - totalSpacing) / itemsInRow;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: cards.map((card) => SizedBox(width: itemWidth, child: card)).toList(),
                    );
                  },
                ),
                Gap(21.h),

                // Enterprise Structure Filters Section
                EnterpriseFiltersCard(isDark: isDark),
                Gap(21.h),

                // Search and Status Filter
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                  ),
                  child: context.isMobile
                      ? Column(
                          children: [
                            DigifyTextField.search(
                              controller: _searchController,
                              showBorder: false,
                              onChanged: (value) => notifier.setSearchQuery(value),
                            ),
                            Gap(16.h),
                            Container(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                            Gap(16.h),
                            Row(
                              children: [
                                DigifyAsset(
                                  assetPath: Assets.icons.leaveManagement.filter.path,
                                  width: 24.w,
                                  height: 24.h,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon,
                                ),
                                Gap(16.w),
                                Expanded(
                                  child: DigifySelectField<TimesheetStatus?>(
                                    hint: 'All Status',
                                    value: state.statusFilter,
                                    items: [
                                      null,
                                      TimesheetStatus.draft,
                                      TimesheetStatus.submitted,
                                      TimesheetStatus.approved,
                                      TimesheetStatus.rejected,
                                    ],
                                    itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                                    onChanged: (value) => notifier.setStatusFilter(value),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: DigifyTextField.search(
                                controller: _searchController,
                                borderColor: Colors.transparent,
                                showBorder: false,
                                hintText: 'Search...',
                                onChanged: (value) => notifier.setSearchQuery(value),
                              ),
                            ),
                            Gap(16.w),
                            DigifyAsset(
                              assetPath: Assets.icons.leaveManagement.filter.path,
                              width: 24.w,
                              height: 24.h,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon,
                            ),
                            Gap(16.w),
                            SizedBox(
                              width: context.screenWidth * .3,

                              child: DigifySelectField<TimesheetStatus?>(
                                hint: 'All Status',
                                value: state.statusFilter,
                                items: [
                                  null,
                                  TimesheetStatus.draft,
                                  TimesheetStatus.submitted,
                                  TimesheetStatus.approved,
                                  TimesheetStatus.rejected,
                                ],
                                itemLabelBuilder: (item) => item == null ? 'All Status' : item.displayName,
                                onChanged: (value) => notifier.setStatusFilter(value),
                              ),
                            ),
                          ],
                        ),
                ),
                Gap(21.h),

                // Timesheet Records Table
                TimesheetTable(records: state.records, isDark: isDark),
                Gap(24.h),

                // Pagination
                AttendancePagination(
                  currentPage: state.currentPage,
                  totalPages: (state.totalItems / state.pageSize).ceil(),
                  totalItems: state.totalItems,
                  itemsPerPage: state.pageSize,
                  onPageChanged: notifier.setPage,
                  onItemsPerPageChanged: (size) {
                    if (size != null) notifier.setPageSize(size);
                  },
                  isDark: isDark,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderTitle(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Sheets',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? null : AppColors.dialogTitle,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(bool isMobile) {
    final actions = [
      ImportButton(onTap: () {}, customLabel: 'Import'),
      Gap(11.w),
      ExportButton(onTap: () {}, customLabel: 'Export'),
      Gap(11.w),
      AppButton(
        fontSize: 14.sp,
        label: 'New Timesheet',
        onPressed: () => NewTimesheetDialog.show(context),
        icon: Icons.add,
        height: 35.h,
        type: AppButtonType.primary,
        borderRadius: BorderRadius.circular(7.0),
      ),
    ];

    if (isMobile) {
      return Wrap(spacing: 12.w, runSpacing: 12.h, children: actions.where((w) => w is! Gap).toList());
    }

    return Row(children: actions);
  }
}
