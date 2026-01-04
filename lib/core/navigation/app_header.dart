import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/localization/locale_provider.dart';
import 'package:digify_hr_system/core/navigation/sidebar_provider.dart';
import 'package:digify_hr_system/core/theme/theme_provider.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      height: isMobile ? 56.h : 72.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 1)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, -1)),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: isMobile ? 12.w : 16.w, vertical: isMobile ? 8.h : 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Menu toggle + Logo
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isMobile) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      ref.read(sidebarProvider.notifier).toggle();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                    child: DigifyAsset(
                      assetPath: Assets.icons.menuToggleIcon.path,
                      width: isMobile ? 18 : 20,
                      height: isMobile ? 18 : 20,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 8.w : 4.w),
                GestureDetector(
                  onTap: () => context.go('/dashboard'),
                  child: SizedBox(
                    height: isMobile ? 40.h : 64.h,
                    width: isMobile ? 60.w : 96.w,
                    child: Image.asset('assets/icons/digify_hr_logo.png', fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
            // Center: Welcome message (hidden on mobile)
            if (!isMobile)
              Expanded(
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: '${localizations.welcome}, ',
                      style: TextStyle(
                        fontSize: isTablet ? 16.sp : 18.8.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                        height: 30 / 18.8,
                        letterSpacing: 0,
                      ),
                      children: [
                        TextSpan(
                          text: localizations.adminUser,
                          style: TextStyle(
                            fontSize: isTablet ? 16.sp : 18.8.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                            height: 30 / 18.8,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            // Right side: Theme toggle, Language switcher, Home, Notifications, User menu
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Theme toggle button
                GestureDetector(
                  onTap: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                    child: Icon(
                      themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                      size: isMobile ? 18.sp : 20.sp,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                    ),
                  ),
                ),
                if (!isMobile) SizedBox(width: 8.w),
                // Language switcher button
                if (!isMobile)
                  GestureDetector(
                    onTap: () {
                      ref.read(localeProvider.notifier).toggleLocale();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                      child: Text(
                        locale.languageCode.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                        ),
                      ),
                    ),
                  ),
                if (!isMobile) SizedBox(width: 8.w),
                if (!isMobile)
                  GestureDetector(
                    onTap: () => context.go('/dashboard'),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                      child: DigifyAsset(
                        assetPath: Assets.icons.homeIcon.path,
                        width: 20,
                        height: 20,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                      ),
                    ),
                  ),
                if (!isMobile) SizedBox(width: 8.w),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                        child: DigifyAsset(
                          assetPath: Assets.icons.notificationsIcon.path,
                          width: isMobile ? 18 : 20,
                          height: isMobile ? 18 : 20,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2.w,
                      top: 2.h,
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(color: const Color(0xFFFB2C36), shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 16 / 12,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isMobile) SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 4.r : 8.r),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: isMobile ? 28.w : 32.w,
                          height: isMobile ? 28.h : 32.h,
                          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: Center(
                            child: DigifyAsset(
                              assetPath: Assets.icons.userIcon.path,
                              width: isMobile ? 16 : 20,
                              height: isMobile ? 16 : 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (!isMobile) ...[
                          SizedBox(width: 8.w),
                          Text(
                            localizations.adminUser,
                            style: TextStyle(
                              fontSize: 15.3.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                              height: 24 / 15.3,
                              letterSpacing: 0,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          DigifyAsset(
                            assetPath: Assets.icons.dropdownArrowIcon.path,
                            width: 16,
                            height: 16,
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
