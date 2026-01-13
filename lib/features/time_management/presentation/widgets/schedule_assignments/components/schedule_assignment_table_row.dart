import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_action_buttons.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/components/shift_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
  final bool isDeleting;

  const ScheduleAssignmentTableRow({
    super.key,
    required this.data,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
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
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(2.h),
                Text(
                  data.assignedToCode,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            274.86.w,
          ),
          _buildDataCell(
            Text(
              data.scheduleName,
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            297.46.w,
          ),
          _buildDataCell(
            Text(
              data.startDate,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            139.55.w,
          ),
          _buildDataCell(
            Text(
              data.endDate,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            136.6.w,
          ),
          _buildDataCell(ShiftStatusBadge(isActive: data.isActive), 117.47.w),
          _buildDataCell(
            Text(
              data.assignedByName,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            197.22.w,
          ),
          _buildDataCell(
            ScheduleAssignmentActionButtons(onView: onView, onEdit: onEdit, onDelete: onDelete, isDeleting: isDeleting),
            135.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
      child: child,
    );
  }
}
