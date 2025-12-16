import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HierarchyPreviewWidget extends StatelessWidget {
  final List<HierarchyPreviewLevel> levels;

  const HierarchyPreviewWidget({
    super.key,
    required this.levels,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.all(17.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.backgroundDark
            : const Color(0xFFF9FAFB),
        border: Border.all(
          color: isDark
              ? AppColors.cardBorderDark
              : const Color(0xFFE5E7EB),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgIconWidget(
                assetPath: 'assets/icons/hierarchy_preview_icon.svg',
                size: 20.sp,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
              ),
              SizedBox(width: 8.w),
              Text(
                localizations.hierarchyPreview,
                style: TextStyle(
                  fontSize: 15.5.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF101828),
                  height: 24 / 15.5,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...levels.map((level) => Padding(
                padding: EdgeInsetsDirectional.only(bottom: 8.h),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: SizedBox(
                    width: level.width.w,
                    child: Row(
                      children: [
                        if (level.level > 1) ...[
                          Text(
                            '└─',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : const Color(0xFF99A1AF),
                              height: 24 / 16,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Container(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 13.w,
                            vertical: 9.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardBackgroundDark
                                : Colors.white,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.cardBorderDark
                                  : const Color(0xFFE5E7EB),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgIconWidget(
                                assetPath: level.icon,
                                size: 16.sp,
                                color: const Color(0xFF9810FA),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                level.name,
                                style: TextStyle(
                                  fontSize: level.level == 1 ? 13.7.sp : 13.8.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : const Color(0xFF101828),
                                  height: 20 / (level.level == 1 ? 13.7 : 13.8),
                                  letterSpacing: 0,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Level ${level.level}',
                                style: TextStyle(
                                  fontSize: 11.8.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textTertiaryDark
                                      : const Color(0xFF6A7282),
                                  height: 16 / 11.8,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
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

  HierarchyPreviewLevel({
    required this.name,
    required this.icon,
    required this.level,
    required this.width,
  });
}

