import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SectionHeaderCard extends StatelessWidget {
  final String? iconAssetPath;
  final Widget? icon;
  final String title;
  final String? subtitle;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const SectionHeaderCard({
    super.key,
    this.iconAssetPath,
    this.icon,
    required this.title,
    this.subtitle,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    assert(
      icon != null || (iconAssetPath != null && iconAssetPath!.isNotEmpty),
      'SectionHeaderCard: Either icon or iconAssetPath must be provided',
    );
    final isDark = context.isDark;
    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    final effectiveRadius = borderRadius ?? 10.r;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(effectiveRadius),
            ),
            alignment: Alignment.center,
            child: icon ?? DigifyAsset(assetPath: iconAssetPath!, width: 20, height: 20, color: AppColors.primary),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.blackTextColor,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  Gap(4.h),
                  Text(
                    subtitle!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
