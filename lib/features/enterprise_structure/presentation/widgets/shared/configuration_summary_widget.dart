import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfigurationSummaryWidget extends StatelessWidget {
  final int totalLevels;
  final int activeLevels;
  final int hierarchyDepth;
  final String topLevel;

  const ConfigurationSummaryWidget({
    super.key,
    required this.totalLevels,
    required this.activeLevels,
    required this.hierarchyDepth,
    required this.topLevel,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsetsDirectional.all(17.w),
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
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.configurationSummary,
            style: TextStyle(
              fontSize: 15.5.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.purpleTextDark
                  : const Color(0xFF59168B),
              height: 24 / 15.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 56.h,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 415.w,
                  top: 0,
                  child: Text.rich(
                    TextSpan(
                      text: '${localizations.totalLevels}: ',
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.purpleTextDark
                            : const Color(0xFF8200DB),
                        height: 20 / 13.6,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF0A0A0A),
                          ),
                        ),
                        TextSpan(
                          text: '$totalLevels',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.purpleTextDark
                                : const Color(0xFF59168B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 415.w,
                  right: 0,
                  top: 0,
                  child: Text.rich(
                    TextSpan(
                      text: '${localizations.activeLevels}: ',
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.purpleTextDark
                            : const Color(0xFF8200DB),
                        height: 20 / 13.6,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF0A0A0A),
                          ),
                        ),
                        TextSpan(
                          text: '$activeLevels',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.purpleTextDark
                                : const Color(0xFF59168B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 415.w,
                  top: 36.h,
                  child: Text.rich(
                    TextSpan(
                      text: '${localizations.hierarchyDepth}: ',
                      style: TextStyle(
                        fontSize: 13.7.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.purpleTextDark
                            : const Color(0xFF8200DB),
                        height: 20 / 13.7,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF0A0A0A),
                          ),
                        ),
                        TextSpan(
                          text: '$hierarchyDepth levels',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.purpleTextDark
                                : const Color(0xFF59168B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 415.w,
                  right: 0,
                  top: 36.h,
                  child: Text.rich(
                    TextSpan(
                      text: '${localizations.topLevel}: ',
                      style: TextStyle(
                        fontSize: 13.6.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.purpleTextDark
                            : const Color(0xFF8200DB),
                        height: 20 / 13.6,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF0A0A0A),
                          ),
                        ),
                        TextSpan(
                          text: topLevel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.purpleTextDark
                                : const Color(0xFF59168B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

