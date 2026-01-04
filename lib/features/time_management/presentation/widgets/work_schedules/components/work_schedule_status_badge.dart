import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkScheduleStatusBadge extends StatelessWidget {
  final bool isActive;

  const WorkScheduleStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.shiftActiveStatusBg : AppColors.shiftInactiveStatusBg,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          color: isActive ? AppColors.greenTextSecondary : AppColors.shiftInactiveStatusText,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
