import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
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
    final columnWidths = [274.86.w, 297.46.w, 139.55.w, 136.6.w, 117.47.w, 197.22.w, 135.w];

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
                  7,
                  (index) => Container(
                    width: columnWidths[index],
                    padding: EdgeInsetsDirectional.only(end: index < 6 ? 24.w : 0),
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
                        7,
                        (colIndex) => Container(
                          width: columnWidths[colIndex],
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
