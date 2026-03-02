import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/common/app_avatar.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/dialogs/mark_attendance_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'attendance_status_chip.dart';

class AttendanceTableRow extends StatelessWidget {
  final AttendanceRecord record;
  final bool isDark;
  final bool isExpanded;
  final VoidCallback onToggle;

  const AttendanceTableRow({
    super.key,
    required this.record,
    required this.isDark,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: AppColors.tableHeaderText);

    return InkWell(
      onTap: onToggle,
      child: Container(
        decoration: BoxDecoration(
          color: isExpanded
              ? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarActiveBg.withAlpha(128))
              : null,
          border: isExpanded
              ? null
              : Border(
                  bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
                ),
        ),
        child: Row(
          children: [
            Gap(24.w),
            AnimatedRotation(
              turns: isExpanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: Icon(
                Icons.keyboard_arrow_right,
                color: isExpanded
                    ? AppColors.statIconBlue
                    : isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.dialogCloseIcon,
                size: 20.r,
              ),
            ),
            if (AttendanceTableConfig.showEmployee)
              _buildDataCell(
                Row(
                  children: [
                    AppAvatar(image: null, fallbackInitial: record.employeeName, size: 35.w),
                    Gap(11.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            record.employeeName.toUpperCase(),
                            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
                          ),
                          Gap(2.h),
                          Text(record.employeeId, style: secondaryStyle),
                        ],
                      ),
                    ),
                  ],
                ),
                AttendanceTableConfig.employeeWidth.w,
              ),
            if (AttendanceTableConfig.showDepartment)
              _buildDataCell(
                Text(
                  (record.departmentName.isEmpty ? record.displayValue(null) : record.departmentName).toUpperCase(),
                  style: textStyle,
                ),
                AttendanceTableConfig.departmentWidth.w,
              ),
            if (AttendanceTableConfig.showDate)
              _buildDataCell(
                Text(DateFormat('MMM d, yyyy').format(record.date), style: textStyle),
                AttendanceTableConfig.dateWidth.w,
              ),
            if (AttendanceTableConfig.showCheckIn)
              _buildDataCell(
                Text(record.displayValue(record.checkIn), style: textStyle),
                AttendanceTableConfig.checkInWidth.w,
              ),
            if (AttendanceTableConfig.showCheckOut)
              _buildDataCell(
                Text(record.displayValue(record.checkOut), style: textStyle),
                AttendanceTableConfig.checkOutWidth.w,
              ),
            if (AttendanceTableConfig.showStatus)
              _buildDataCell(AttendanceStatusChip(status: record.status), AttendanceTableConfig.statusWidth.w),
            if (AttendanceTableConfig.showActions)
              _buildDataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigifyAssetButton(
                      assetPath: Assets.icons.editIconGreen.path,
                      onTap: () {
                        if (record.attendance != null) {
                          MarkAttendanceDialog.show(context, attendanceRecord: record);
                        }
                      },
                      width: 17.w,
                      height: 17.h,
                      color: AppColors.editIconGreen,
                    ),
                    Gap(8.w),
                    DigifyAssetButton(
                      assetPath: Assets.icons.locationIcon.path,
                      onTap: () {},
                      width: 17.w,
                      height: 17.h,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                AttendanceTableConfig.actionsWidth.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: AttendanceTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      child: child,
    );
  }
}
