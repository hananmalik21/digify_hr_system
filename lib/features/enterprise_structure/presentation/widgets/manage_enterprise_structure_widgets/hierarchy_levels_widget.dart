import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Hierarchy levels widget
class HierarchyLevelsWidget extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final List<String> levels;
  final int levelCount;

  const HierarchyLevelsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.levels,
    required this.levelCount,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    final levelLabels = {
      'Company': localizations.company,
      'Division': localizations.division,
      'Business Unit': localizations.businessUnit,
      'Department': localizations.department,
      'Sections': localizations.section,
    };

    final levelIcons = {
      'Company': 'assets/icons/company_icon_purple.svg',
      'Division': 'assets/icons/assets/icons/division_icon_purple.svg',
      'Business Unit': 'assets/icons/business_unit_icon.svg',
      'Department': 'assets/icons/department_icon.svg',
      'Sections': 'assets/icons/section_icon_purple.svg',
      'Updated Division': 'assets/icons/division_icon_purple.svg',
    };

    return Wrap(
      spacing: isMobile ? 6.w : (isTablet ? 7.w : 8.w),
      runSpacing: isMobile ? 6.h : 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          localizations.hierarchy,
          style: TextStyle(
            fontSize: isMobile ? 12.sp : (isTablet ? 13.sp : 13.7.sp),
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textTertiaryDark
                : const Color(0xFF6A7282),
            height: 20 / 13.7,
            letterSpacing: 0,
          ),
        ),
        ...levels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: isMobile ? 7.w : (isTablet ? 8.w : 9.w),
                  vertical: isMobile ? 4.h : 5.h,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.purpleBgDark
                      : const Color(0xFFFAF5FF),
                  border: Border.all(
                    color: isDark
                        ? AppColors.purpleBorderDark
                        : const Color(0xFFE9D4FF),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgIconWidget(
                      assetPath: levelIcons[level] ?? '',
                      size: isMobile ? 12.sp : (isTablet ? 13.sp : 14.sp),
                      color: isDark
                          ? AppColors.purpleTextDark
                          : const Color(0xFF59168B),
                    ),
                    SizedBox(width: isMobile ? 3.w : 4.w),
                    Text(
                      levelLabels[level] ?? level,
                      style: TextStyle(
                        fontSize: isMobile
                            ? 11.sp
                            : (isTablet ? 11.5.sp : 12.sp),
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.purpleTextDark
                            : const Color(0xFF59168B),
                        height: 16 / 12,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < levels.length - 1) ...[
                SizedBox(width: isMobile ? 6.w : (isTablet ? 7.w : 8.w)),
                Text(
                  '→',
                  style: TextStyle(
                    fontSize: isMobile ? 14.sp : (isTablet ? 15.sp : 16.sp),
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textPlaceholderDark
                        : const Color(0xFF99A1AF),
                    height: 24 / 16,
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(width: isMobile ? 6.w : (isTablet ? 7.w : 8.w)),
              ],
            ],
          );
        }),
        SizedBox(width: isMobile ? 6.w : (isTablet ? 7.w : 8.w)),
        Text(
          '($levelCount ${localizations.levels})',
          style: TextStyle(
            fontSize: isMobile ? 11.sp : (isTablet ? 11.5.sp : 12.sp),
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textTertiaryDark
                : const Color(0xFF6A7282),
            height: 16 / 12,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

