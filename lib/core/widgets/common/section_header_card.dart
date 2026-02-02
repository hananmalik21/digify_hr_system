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
    final effectivePadding = padding ?? EdgeInsets.all(14.0);
    final effectiveRadius = borderRadius ?? 10.r;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(effectiveRadius),
            ),
            alignment: Alignment.center,
            child: icon ?? DigifyAsset(assetPath: iconAssetPath!, width: 17, height: 17, color: AppColors.primary),
          ),
          Gap(11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  Gap(4.h),
                  Text(
                    subtitle!,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.shiftExportButton,
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
