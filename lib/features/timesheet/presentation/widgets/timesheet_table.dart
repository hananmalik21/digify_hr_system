import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/digify_capsule.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet_status.dart';
import 'package:digify_hr_system/features/timesheet/presentation/providers/timesheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../gen/assets.gen.dart';

class TimesheetTable extends ConsumerWidget {
  final List<Timesheet> records;
  final bool isDark;

  const TimesheetTable({super.key, required this.records, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Timesheet Records', style: context.textTheme.titleSmall?.copyWith(color: context.isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle)),
                Gap(4.h),
                Text(
                  'Showing ${records.length} of ${records.length} timesheets',
                  style: context.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400, color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Scrollable Table Content
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate minimum table width based on content
              final minTableWidth = 1000.w;
              final availableWidth = constraints.maxWidth;
              final tableWidth = minTableWidth > availableWidth ? minTableWidth : availableWidth;

              return ScrollableSingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: tableWidth),
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table Header Row
                        Container(width: double.infinity, height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                        _buildTableHeader(context),
                        Container(width: double.infinity, height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                        // Table Data Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: records.length,
                          separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                          itemBuilder: (context, index) {
                            final timesheet = records[index];
                            return _buildTableRow(context, timesheet, ref);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final headerStyle = context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 11.h),
      color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Employee', style: headerStyle)),
          Expanded(flex: 2, child: Text('Department', style: headerStyle)),
          Expanded(flex: 2, child: Text('Week Period', style: headerStyle)),
          Expanded(flex: 2, child: Text('Regular Hours', style: headerStyle)),
          Expanded(flex: 2, child: Text('Overtime Hours', style: headerStyle)),
          Expanded(flex: 2, child: Text('Total Hours', style: headerStyle)),
          SizedBox(
            width: 150.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text('Status', style: headerStyle),
            ),
          ),
          SizedBox(
            width: 120.w,
            child: Text('Actions', style: headerStyle, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Timesheet timesheet, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Employee
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.jobRoleBg,
                  child: Text(
                    timesheet.avatarInitials,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.statIconBlue, fontFamily: 'Inter'),
                  ),
                ),
                Gap(6.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timesheet.employeeName, style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle)),
                    Gap(2.h),
                    Text(
                      timesheet.employeeNumber,
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Department
          Expanded(
            flex: 2,
            child: Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.attendance.enterprise.path, width: 10.w, height: 10.h, color: AppColors.primary),
                Gap(4.w),
                Text(timesheet.departmentName, style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
              ],
            ),
          ),
          // Week Period
          Expanded(
            flex: 2,
            child: Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.attendance.emptyCalander.path, width: 13.w, height: 13.h, color: AppColors.primary),
                Gap(4.w),
                Flexible(
                  child: Text(
                    timesheet.formattedWeekPeriod,
                    style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          // Regular Hours
          Expanded(
            flex: 2,
            child: Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.clockIcon.path, width: 14.w, height: 14.h, color: AppColors.primary),
                Gap(4.w),
                Text('${timesheet.regularHours.toInt()}h', style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
              ],
            ),
          ),
          // Overtime Hours
          Expanded(
            flex: 2,
            child: Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.attendance.halfDay.path, width: 14.w, height: 14.h, color: AppColors.primary),
                Gap(4.w),
                Text('${timesheet.overtimeHours.toInt()}h', style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
              ],
            ),
          ),
          // Total Hours
          Expanded(
            flex: 2,
            child: Text('${timesheet.totalHours.toInt()}h', style: context.textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel)),
          ),
          // Status
          SizedBox(
            width: 150.w,
            child: Row(mainAxisSize: MainAxisSize.min, children: [Gap(10.w), _buildStatusChip(timesheet.status)]),
          ),
          // Actions
          SizedBox(
            width: 120.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // TODO: Implement view timesheet details
                  },
                  child: Icon(Icons.visibility_outlined, size: 18.r, color: AppColors.primary),
                ),
                if (timesheet.status == TimesheetStatus.submitted) ...[
                  Gap(12.w),
                  InkWell(
                    onTap: () {
                      ref.read(timesheetNotifierProvider.notifier).approveTimesheet(timesheet.id);
                    },
                    child: Icon(Icons.check_circle_outline, size: 18.r, color: Colors.green),
                  ),
                  Gap(12.w),
                  InkWell(
                    onTap: () {
                      // TODO: Show reject dialog
                      ref.read(timesheetNotifierProvider.notifier).rejectTimesheet(timesheet.id, 'Rejected by manager');
                    },
                    child: Icon(Icons.cancel_outlined, size: 18.r, color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TimesheetStatus status) {
    Color bgColor;
    Color textColor;
    String? path;
    IconData? icon;

    switch (status) {
      case TimesheetStatus.draft:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
        path = Assets.icons.headIcon.path;

        break;
      case TimesheetStatus.submitted:
        bgColor = const Color(0xFFEFF6FF);
        textColor = AppColors.primary;
        path = Assets.icons.submitted.path;
        break;
      case TimesheetStatus.approved:
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF166534);
        path = Assets.icons.activeUnitsIcon.path;
        break;
      case TimesheetStatus.rejected:
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFF991B1B);
        icon = Icons.cancel_outlined;
        break;
    }

    return path != null
        ? DigifyCapsule(label: status.displayName, backgroundColor: bgColor, textColor: textColor, iconPath: path)
        : DigifyCapsule(label: status.displayName, backgroundColor: bgColor, textColor: textColor, icon: icon);
  }
}
