import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkScheduleCardSkeleton extends StatelessWidget {
  const WorkScheduleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final padding = ResponsiveHelper.getCardPadding(context);

    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          boxShadow: [
            BoxShadow(color: const Color(0xFF000000).withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header skeleton
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: 200.w,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 14.h,
                          width: 150.w,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 24.h,
                    width: 60.w,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12.r)),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Content skeleton
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Weekly schedule skeleton
              Container(
                height: 14.h,
                width: 120.w,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
              ),
              SizedBox(height: 8.h),
              Row(
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Container(
                      height: 52.h,
                      margin: EdgeInsets.only(right: index < 6 ? 8.w : 0),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Actions skeleton
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                padding: EdgeInsets.only(top: 17.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
