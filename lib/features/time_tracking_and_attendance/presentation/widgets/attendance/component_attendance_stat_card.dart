import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? iconPath;
  final IconData? icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final bool isDark;

  const AttendanceStatCard({
    super.key,
    required this.label,
    required this.value,
    this.iconPath,
    this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.isDark,
  }) : assert(iconPath == null || icon == null, 'Cannot provide both iconPath and icon');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : Color(0xFF4A5565),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(8.h),
                Text(
                  value,
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : Color(0xFF0F172B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: iconPath != null
                ? DigifyAsset(
                    assetPath: iconPath!,
                    color: iconColor,
                    width: 24,
                    height: 24,
                  )
                : Icon(
                    icon,
                    size: 24.sp,
                    color: iconColor,
                  ),
          ),
        ],
      ),
    );
  }
}
