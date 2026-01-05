import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/data/custom_status_cell.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentTableRowData {
  final int scheduleAssignmentId;
  final String assignedToName;
  final String assignedToCode;
  final String scheduleName;
  final String startDate;
  final String endDate;
  final bool isActive;
  final String assignedByName;

  const ScheduleAssignmentTableRowData({
    required this.scheduleAssignmentId,
    required this.assignedToName,
    required this.assignedToCode,
    required this.scheduleName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.assignedByName,
  });
}

class ScheduleAssignmentTableRow extends StatelessWidget {
  final ScheduleAssignmentTableRowData data;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleAssignmentTableRow({super.key, required this.data, this.onView, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.assignedToName,
                  style: TextStyle(
                    fontSize: 13.7.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 20 / 13.7,
                  ),
                ),
                Text(
                  data.assignedToCode,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
            274.86.w,
          ),
          _buildDataCell(
            Text(
              data.scheduleName,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
            ),
            297.46.w,
          ),
          _buildDataCell(
            Text(
              data.startDate,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            139.55.w,
          ),
          _buildDataCell(
            Text(
              data.endDate,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
            ),
            136.6.w,
          ),
          _buildDataCell(
            CustomStatusCell(isActive: data.isActive, activeLabel: 'ACTIVE', inactiveLabel: 'INACTIVE'),
            117.47.w,
          ),
          _buildDataCell(
            Text(
              data.assignedByName,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.7,
              ),
            ),
            197.22.w,
          ),
          _buildActionCell(ScheduleAssignmentActionButtons(onView: onView, onEdit: onEdit, onDelete: onDelete), 135.w),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      clipBehavior: Clip.none,
      child: child,
    );
  }

  Widget _buildActionCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.only(start: 24.w, top: 16.h, bottom: 16.h, end: 20.w),
      clipBehavior: Clip.none,
      child: child,
    );
  }
}
