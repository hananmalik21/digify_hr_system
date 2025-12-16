import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/localization/locale_provider.dart';
import 'package:digify_hr_system/core/navigation/sidebar_provider.dart';
import 'package:digify_hr_system/core/theme/theme_provider.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
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
    
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 4.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Menu toggle + Logo
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(sidebarProvider.notifier).toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/menu_toggle_icon.svg',
                      size: 20.sp,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                GestureDetector(
                  onTap: () => context.go('/dashboard'),
                  child: SizedBox(
                    height: 64.h,
                    width: 96.w,
                    child: Image.asset(
                      'assets/icons/digify_hr_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            // Center: Welcome message
            Text.rich(
              TextSpan(
                text: '${localizations.welcome}, ',
                style: TextStyle(
                  fontSize: 18.8.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                  height: 30 / 18.8,
                  letterSpacing: 0,
                ),
                children: [
                  TextSpan(
                    text: localizations.adminUser,
                    style: TextStyle(
                      fontSize: 18.8.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      height: 30 / 18.8,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
            // Right side: Theme toggle, Language switcher, Home, Notifications, User menu
            Row(
              children: [
                // Theme toggle button
                GestureDetector(
                  onTap: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                      size: 20.sp,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Language switcher button
                GestureDetector(
                  onTap: () {
                    ref.read(localeProvider.notifier).toggleLocale();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
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
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => context.go('/dashboard'),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/home_icon.svg',
                      size: 20.sp,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1E2939),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Open notifications
                      },
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: SvgIconWidget(
                          assetPath: 'assets/icons/notifications_icon.svg',
                          size: 20.sp,
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB2C36),
                          shape: BoxShape.circle,
                        ),
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
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    // TODO: Open user menu
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgIconWidget(
                              assetPath: 'assets/icons/user_icon.svg',
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                        SvgIconWidget(
                          assetPath: 'assets/icons/dropdown_arrow_icon.svg',
                          size: 16.sp,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                        ),
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

