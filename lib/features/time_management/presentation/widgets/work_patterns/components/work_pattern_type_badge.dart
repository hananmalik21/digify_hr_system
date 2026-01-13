import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkPatternTypeBadge extends StatelessWidget {
  final String type;

  const WorkPatternTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.workPatternBadgeBgDark : AppColors.workPatternBadgeBgLight,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        type,
        style: context.textTheme.labelMedium?.copyWith(
          color: isDark ? AppColors.workPatternBadgeTextDark : AppColors.workPatternBadgeTextLight,
        ),
      ),
    );
  }
}
