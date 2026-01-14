import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/time_management/data/config/schedule_assignments_table_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScheduleAssignmentsTableSkeleton extends StatelessWidget {
  final int itemCount;

  const ScheduleAssignmentsTableSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final headerColor = isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB);

    final columnWidths = <double>[];
    if (ScheduleAssignmentsTableConfig.showAssignedTo) {
      columnWidths.add(ScheduleAssignmentsTableConfig.assignedToWidth);
    }
    if (ScheduleAssignmentsTableConfig.showSchedule) {
      columnWidths.add(ScheduleAssignmentsTableConfig.scheduleWidth);
    }
    if (ScheduleAssignmentsTableConfig.showStartDate) {
      columnWidths.add(ScheduleAssignmentsTableConfig.startDateWidth);
    }
    if (ScheduleAssignmentsTableConfig.showEndDate) {
      columnWidths.add(ScheduleAssignmentsTableConfig.endDateWidth);
    }
    if (ScheduleAssignmentsTableConfig.showStatus) {
      columnWidths.add(ScheduleAssignmentsTableConfig.statusWidth);
    }
    if (ScheduleAssignmentsTableConfig.showAssignedBy) {
      columnWidths.add(ScheduleAssignmentsTableConfig.assignedByWidth);
    }
    if (ScheduleAssignmentsTableConfig.showActions) {
      columnWidths.add(ScheduleAssignmentsTableConfig.actionsWidth);
    }

    final columnCount = columnWidths.length;

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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: headerColor,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                children: List.generate(
                  columnCount,
                  (index) => Container(
                    width: columnWidths[index].w,
                    padding: EdgeInsetsDirectional.only(end: index < columnCount - 1 ? 24.w : 0),
                    child: Container(
                      height: 16.h,
                      decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                ),
              ),
            ),
            Skeletonizer(
              enabled: true,
              child: Column(
                children: List.generate(
                  itemCount,
                  (index) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
                      ),
                    ),
                    child: Row(
                      children: List.generate(
                        columnCount,
                        (colIndex) => Container(
                          width: columnWidths[colIndex].w,
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w, vertical: 16.h),
                          child: Container(
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
