import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceTableHeader extends StatelessWidget {
  final bool isDark;

  const AttendanceTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
      child: Row(
        children: [
          Gap(40.w),
          if (AttendanceTableConfig.showEmployee)
            _buildHeaderCell(context, 'Employee', AttendanceTableConfig.employeeWidth.w),
          if (AttendanceTableConfig.showDepartment)
            _buildHeaderCell(context, 'Department', AttendanceTableConfig.departmentWidth.w),
          if (AttendanceTableConfig.showDate) _buildHeaderCell(context, 'Date', AttendanceTableConfig.dateWidth.w),
          if (AttendanceTableConfig.showCheckIn)
            _buildHeaderCell(context, 'Check In', AttendanceTableConfig.checkInWidth.w),
          if (AttendanceTableConfig.showCheckOut)
            _buildHeaderCell(context, 'Check Out', AttendanceTableConfig.checkOutWidth.w),
          if (AttendanceTableConfig.showStatus)
            _buildHeaderCell(context, 'Status', AttendanceTableConfig.statusWidth.w),
          if (AttendanceTableConfig.showActions)
            _buildHeaderCell(context, 'Actions', AttendanceTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, double width, {TextAlign textAlign = TextAlign.left}) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AttendanceTableConfig.cellPaddingHorizontal.w,
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
