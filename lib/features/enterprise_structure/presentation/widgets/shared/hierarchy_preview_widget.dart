import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HierarchyPreviewWidget extends StatelessWidget {
  final List<HierarchyPreviewLevel> levels;

  const HierarchyPreviewWidget({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(12.w),
        tablet: EdgeInsetsDirectional.all(14.w),
        web: EdgeInsetsDirectional.all(17.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB), width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.hierarchyPreviewIcon.path,
                width: isMobile ? 18 : (isTablet ? 19 : 20),
                height: isMobile ? 18 : (isTablet ? 19 : 20),
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              ),
              SizedBox(width: isMobile ? 6.w : 8.w),
              Text(
                localizations.hierarchyPreview,
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.5.sp),
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                  height: 24 / 15.5,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 10.h : 12.h),
          ...levels.map(
            (level) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: isMobile ? 6.h : 8.h),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SizedBox(
                  width: isMobile ? double.infinity : (isTablet ? (level.width * 0.85).w : level.width.w),
                  child: Row(
                    children: [
                      if (level.level > 1) ...[
                        Text(
                          '└─',
                          style: TextStyle(
                            fontSize: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
                            color: isDark ? AppColors.textTertiaryDark : const Color(0xFF99A1AF),
                            height: 24 / 16,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(width: isMobile ? 6.w : 8.w),
                      ],
                      Flexible(
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: isMobile ? 10.w : (isTablet ? 12.w : 13.w),
                            vertical: isMobile ? 7.h : (isTablet ? 8.h : 9.h),
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                            border: Border.all(
                              color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DigifyAsset(
                                assetPath: level.icon,
                                width: isMobile ? 14 : (isTablet ? 15 : 16),
                                height: isMobile ? 14 : (isTablet ? 15 : 16),
                                color: const Color(0xFF9810FA),
                              ),
                              SizedBox(width: isMobile ? 6.w : 8.w),
                              Flexible(
                                child: Text(
                                  level.name,
                                  style: TextStyle(
                                    fontSize: isMobile
                                        ? 12.sp
                                        : (isTablet
                                              ? (level.level == 1 ? 13.sp : 13.2.sp)
                                              : (level.level == 1 ? 13.7.sp : 13.8.sp)),
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                                    height: 20 / (level.level == 1 ? 13.7 : 13.8),
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: isMobile ? 6.w : 8.w),
                              Text(
                                'Level ${level.level}',
                                style: TextStyle(
                                  fontSize: isMobile ? 10.sp : (isTablet ? 11.sp : 11.8.sp),
                                  fontWeight: FontWeight.w400,
                                  color: isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
                                  height: 16 / 11.8,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HierarchyPreviewLevel {
  final String name;
  final String icon;
  final int level;
  final double width;

  HierarchyPreviewLevel({required this.name, required this.icon, required this.level, required this.width});
}
