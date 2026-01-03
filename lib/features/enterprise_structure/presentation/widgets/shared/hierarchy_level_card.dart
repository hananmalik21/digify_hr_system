import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HierarchyLevelCard extends StatelessWidget {
  final String name;
  final String icon;
  final int levelNumber;
  final bool isMandatory;
  final bool isActive;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final ValueChanged<bool>? onToggleActive;

  const HierarchyLevelCard({
    super.key,
    required this.name,
    required this.icon,
    required this.levelNumber,
    required this.isMandatory,
    required this.isActive,
    required this.canMoveUp,
    required this.canMoveDown,
    this.onMoveUp,
    this.onMoveDown,
    this.onToggleActive,
  });

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
        tablet: EdgeInsetsDirectional.all(15.w),
        web: EdgeInsetsDirectional.all(18.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
        border: Border.all(color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF), width: 2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9810FA),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: DigifyAsset(assetPath: icon, width: 16, height: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                                  height: 24 / 15.5,
                                  letterSpacing: 0,
                                ),
                              ),
                              if (isMandatory)
                                Container(
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.errorBgDark : const Color(0xFFFFE2E2),
                                    border: Border.all(
                                      color: isDark ? AppColors.errorBorderDark : const Color(0xFFFFC9C9),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    localizations.mandatory,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: isDark ? AppColors.errorTextDark : const Color(0xFFC10007),
                                      height: 16 / 11.8,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 7.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7),
                                  border: Border.all(
                                    color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  localizations.active,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                                    height: 16 / 11.8,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Level $levelNumber in the hierarchy',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                              height: 20 / 13.6,
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: canMoveUp ? onMoveUp : null,
                          child: Container(
                            padding: EdgeInsetsDirectional.all(6.w),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
                            child: DigifyAsset(
                              assetPath: Assets.icons.upArrowIcon.path,
                              width: 18,
                              height: 18,
                              color: canMoveUp
                                  ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828))
                                  : (isDark ? AppColors.textTertiaryDark : const Color(0xFF9CA3AF)),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: canMoveDown ? onMoveDown : null,
                          child: Container(
                            padding: EdgeInsetsDirectional.all(6.w),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
                            child: DigifyAsset(
                              assetPath: Assets.icons.downArrowIcon.path,
                              width: 18,
                              height: 18,
                              color: canMoveDown
                                  ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828))
                                  : (isDark ? AppColors.textTertiaryDark : const Color(0xFF9CA3AF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50.w,
                      height: 28.h,
                      child: Switch(
                        value: isActive,
                        onChanged: isMandatory ? null : onToggleActive,
                        activeTrackColor: const Color(0xFF00A63E),
                        activeThumbColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: isDark ? AppColors.cardBorderDark : const Color(0xFFD1D5DC),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: isTablet ? 30.w : 32.w,
                        height: isTablet ? 30.h : 32.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9810FA),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Center(
                          child: DigifyAsset(
                            assetPath: icon,
                            width: isTablet ? 18 : 20,
                            height: isTablet ? 18 : 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 6.w : 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: isTablet ? 6.w : 8.w,
                              runSpacing: 4.h,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: isTablet ? 14.5.sp : 15.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                                    height: 24 / 15.5,
                                    letterSpacing: 0,
                                  ),
                                ),
                                if (isMandatory)
                                  Container(
                                    padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: isTablet ? 8.w : 9.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.errorBgDark : const Color(0xFFFFE2E2),
                                      border: Border.all(
                                        color: isDark ? AppColors.errorBorderDark : const Color(0xFFFFC9C9),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      localizations.mandatory,
                                      style: TextStyle(
                                        fontSize: isTablet ? 11.sp : 11.8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: isDark ? AppColors.errorTextDark : const Color(0xFFC10007),
                                        height: 16 / 11.8,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                Container(
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: isTablet ? 8.w : 9.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7),
                                    border: Border.all(
                                      color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    localizations.active,
                                    style: TextStyle(
                                      fontSize: isTablet ? 11.sp : 11.8.sp,
                                      fontWeight: FontWeight.w400,
                                      color: isDark ? AppColors.successTextDark : const Color(0xFF008236),
                                      height: 16 / 11.8,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Level $levelNumber in the hierarchy',
                              style: TextStyle(
                                fontSize: isTablet ? 12.5.sp : 13.6.sp,
                                fontWeight: FontWeight.w400,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                                height: 20 / 13.6,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 6.w : 8.w),
                Column(
                  children: [
                    GestureDetector(
                      onTap: canMoveUp ? onMoveUp : null,
                      child: Container(
                        padding: EdgeInsetsDirectional.all(4.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
                        child: DigifyAsset(
                          assetPath: Assets.icons.upArrowIcon.path,
                          width: isTablet ? 15 : 16,
                          height: isTablet ? 15 : 16,
                          color: canMoveUp
                              ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828))
                              : (isDark ? AppColors.textTertiaryDark : const Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: canMoveDown ? onMoveDown : null,
                      child: Container(
                        padding: EdgeInsetsDirectional.all(4.w),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
                        child: DigifyAsset(
                          assetPath: Assets.icons.downArrowIcon.path,
                          width: isTablet ? 15 : 16,
                          height: isTablet ? 15 : 16,
                          color: canMoveDown
                              ? (isDark ? AppColors.textPrimaryDark : const Color(0xFF101828))
                              : (isDark ? AppColors.textTertiaryDark : const Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: isTablet ? 6.w : 8.w),
                SizedBox(
                  width: isTablet ? 42.w : 44.w,
                  height: isTablet ? 22.h : 24.h,
                  child: Switch(
                    value: isActive,
                    onChanged: isMandatory ? null : onToggleActive,
                    activeTrackColor: const Color(0xFF00A63E),
                    activeThumbColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: isDark ? AppColors.cardBorderDark : const Color(0xFFD1D5DC),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
    );
  }
}
