import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftStatusBadge extends StatelessWidget {
  final bool isActive;

  const ShiftStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.shiftActiveStatusBg
            : AppColors.shiftInactiveStatusBg,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          color: isActive
              ? AppColors.shiftActiveStatusText
              : AppColors.shiftInactiveStatusText,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
