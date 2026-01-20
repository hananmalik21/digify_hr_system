import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A reusable capsule/pill-shaped badge widget

class DigifyCapsule extends StatelessWidget {
  final String label;
  final String? iconPath;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final VoidCallback? onTap;

  const DigifyCapsule({
    super.key,
    required this.label,
    this.iconPath,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.onTap,
  }) : assert(iconPath == null || icon == null, 'Cannot provide both iconPath and icon');

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveBackgroundColor = backgroundColor ?? (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg);
    final effectiveTextColor = textColor ?? (isDark ? context.themeTextPrimary : AppColors.textPrimary);
    final effectiveBorderColor = borderColor ?? (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPath != null || icon != null) ...[
          iconPath != null
              ? DigifyAsset(assetPath: iconPath!, width: 14, height: 14, color: effectiveTextColor)
              : Icon(icon, size: 14.sp, color: effectiveTextColor),
          Gap(4.w),
        ],
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: effectiveTextColor),
        ),
      ],
    );

    final container = Container(
      width: width,
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: borderColor != null ? Border.all(color: effectiveBorderColor, width: 1) : null,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: width != null ? Center(child: content) : content,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
