import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({super.key, required this.themeMode, required this.onToggle, this.isDark = false});

  final ThemeMode themeMode;
  final VoidCallback onToggle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isLightSelected = themeMode == ThemeMode.light;
    final trackColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
    final selectedBg = isDark ? AppColors.primaryDark : AppColors.primary;
    final unselectedColor = isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
    final selectedColor = Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 74.w,
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey, width: 1),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: isLightSelected ? 0.w : 34.w,
                top: 3.h,
                bottom: 3.h,
                child: Container(
                  width: 30.w,
                  decoration: BoxDecoration(color: selectedBg, borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
              Positioned(
                top: 3.h,
                bottom: 3.h,
                width: 30.w,
                child: Center(
                  child: Icon(
                    Icons.light_mode_rounded,
                    size: 18.sp,
                    color: isLightSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ),
              Positioned(
                left: 34.w,
                top: 3.h,
                bottom: 3.h,
                width: 30.w,
                child: Center(
                  child: Icon(
                    Icons.dark_mode_rounded,
                    size: 18.sp,
                    color: isLightSelected ? unselectedColor : selectedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
