import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/config/timesheet_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesheetTableHeader extends StatelessWidget {
  final bool isDark;

  const TimesheetTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          if (TimesheetTableConfig.showEmployee)
            _buildHeaderCell(context, 'Employee', TimesheetTableConfig.employeeWidth.w),
          if (TimesheetTableConfig.showDepartment)
            _buildHeaderCell(context, 'Department', TimesheetTableConfig.departmentWidth.w),
          if (TimesheetTableConfig.showWeekPeriod)
            _buildHeaderCell(context, 'Week Period', TimesheetTableConfig.weekPeriodWidth.w),
          if (TimesheetTableConfig.showRegularHours)
            _buildHeaderCell(context, 'Regular Hours', TimesheetTableConfig.regularHoursWidth.w),
          if (TimesheetTableConfig.showOvertimeHours)
            _buildHeaderCell(context, 'Overtime Hours', TimesheetTableConfig.overtimeHoursWidth.w),
          if (TimesheetTableConfig.showTotalHours)
            _buildHeaderCell(context, 'Total Hours', TimesheetTableConfig.totalHoursWidth.w),
          if (TimesheetTableConfig.showStatus) _buildHeaderCell(context, 'Status', TimesheetTableConfig.statusWidth.w),
          if (TimesheetTableConfig.showActions)
            _buildHeaderCell(context, 'Actions', TimesheetTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {TextAlign textAlign = TextAlign.left}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: TimesheetTableConfig.cellPaddingHorizontal.w,
        vertical: 14.h,
      ),
      alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        textAlign: textAlign,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.tableHeaderText),
      ),
    );
  }
}
