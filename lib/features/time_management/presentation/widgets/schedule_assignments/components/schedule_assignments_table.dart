import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/scrollable_wrapper.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_header.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignment_table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentsTable extends StatelessWidget {
  final List<ScheduleAssignmentTableRowData> assignments;
  final Function(ScheduleAssignmentTableRowData)? onView;
  final Function(ScheduleAssignmentTableRowData)? onEdit;
  final Function(ScheduleAssignmentTableRowData)? onDelete;
  final int? deletingAssignmentId;

  const ScheduleAssignmentsTable({
    super.key,
    required this.assignments,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.deletingAssignmentId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), offset: const Offset(0, 1), blurRadius: 3),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScheduleAssignmentTableHeader(),
            if (assignments.isEmpty)
              SizedBox(
                width: 1200.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: Center(
                    child: Text(
                      'No schedule assignments found',
                      style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                    ),
                  ),
                ),
              )
            else
              ...assignments.map(
                (assignment) => ScheduleAssignmentTableRow(
                  data: assignment,
                  onView: onView != null ? () => onView!(assignment) : null,
                  onEdit: onEdit != null ? () => onEdit!(assignment) : null,
                  onDelete: onDelete != null ? () => onDelete!(assignment) : null,
                  isDeleting: deletingAssignmentId == assignment.scheduleAssignmentId,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
