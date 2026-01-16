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

    return Material(
      // ✅ Ensures PopupMenu overlay works correctly on Web/Desktop
      color: Colors.transparent,
      child: Container(
        height: isMobile ? 56.h : 72.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 3, offset: const Offset(0, 1)),
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
                    behavior: HitTestBehavior.opaque,
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
                  SizedBox(
                    height: isMobile ? 40.h : 100.h,
                    width: isMobile ? 80.w : 120.w,
                    child: Image.asset('assets/icons/digify_hr_logo.png', fit: BoxFit.cover),
                  ),

                  SizedBox(width: isMobile ? 8.w : 4.w),
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
                        ),
                        children: [
                          TextSpan(
                            text: localizations.adminUser,
                            style: TextStyle(
                              fontSize: isTablet ? 16.sp : 18.8.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              height: 30 / 18.8,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

              // Right side
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Theme toggle
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
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

                  // Language switcher
                  if (!isMobile)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
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

                  // Home
                  if (!isMobile)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
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

                  // Notifications (✅ constrained so it doesn't block clicks)
                  SizedBox(
                    width: isMobile ? 34.w : 36.w,
                    height: isMobile ? 34.h : 36.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
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
                        ),
                        Positioned(
                          right: 2.w,
                          top: 2.h,
                          child: Container(
                            width: 16.w,
                            height: 16.h,
                            decoration: const BoxDecoration(color: Color(0xFFFB2C36), shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  height: 16 / 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isMobile) SizedBox(width: 8.w),

                  // ✅ User Menu (PopupMenuButton only trigger)
                  Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        textStyle: TextStyle(
                          color: const Color(0xFF364153),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                        ),
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      tooltip: '',
                      offset: const Offset(0, 50),
                      elevation: 10,
                      shadowColor: Colors.black.withValues(alpha: 0.10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      onOpened: () => debugPrint('✅ Popup opened'),
                      onCanceled: () => debugPrint('⚠️ Popup canceled'),
                      onSelected: (value) {
                        debugPrint('Selected: $value');
                      },
                      itemBuilder: (context) => [
                        // Header (disabled)
                        PopupMenuItem<String>(
                          enabled: false,
                          padding: EdgeInsets.zero,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48.w,
                                  height: 48.h,
                                  decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                                  child: Center(
                                    child: DigifyAsset(
                                      assetPath: 'assets/icons/user_icon.svg',
                                      width: 24.sp,
                                      height: 24.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'System Administrator',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E2939),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'admin@digifyhr.com',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        _buildMenuItem(
                          value: 'profile',
                          label: 'My Profile',
                          iconPath: 'assets/icons/user_icon.svg',
                          isSvg: true,
                        ),
                        _buildMenuItem(
                          value: 'desktop_tabs',
                          label: 'Manage Desktop Tabs',
                          iconData: Icons.folder_open_outlined,
                        ),
                        _buildMenuItem(
                          value: 'system_settings',
                          label: 'System Settings',
                          iconData: Icons.dns_outlined,
                        ),
                        _buildMenuItem(
                          value: 'settings',
                          label: 'Settings',
                          iconPath: 'assets/icons/settings_icon.svg',
                          isSvg: true,
                        ),
                        _buildMenuItem(
                          value: 'change_password',
                          label: 'Change Password',
                          iconPath: 'assets/icons/lock_icon.svg',
                          isSvg: true,
                        ),

                        const PopupMenuDivider(height: 1),

                        PopupMenuItem<String>(
                          value: 'logout',
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24.w,
                                child: Icon(Icons.logout_rounded, size: 20.sp, color: const Color(0xFFEF4444)),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                localizations.logout,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Padding(
                        // ✅ small padding expands click target on web
                        padding: EdgeInsets.all(2.r),
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 4.r : 8.r),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: isMobile ? 28.w : 32.w,
                                height: isMobile ? 28.h : 32.h,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                child: Center(
                                  child: DigifyAsset(
                                    assetPath: 'assets/icons/user_icon.svg',
                                    height: isMobile ? 16.sp : 20.sp,
                                    width: isMobile ? 16.sp : 20.sp,
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
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                DigifyAsset(
                                  assetPath: 'assets/icons/dropdown_arrow_icon.svg',
                                  height: 16.sp,
                                  width: 16.sp,
                                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String label,
    String? iconPath,
    IconData? iconData,
    bool isSvg = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: isSvg && iconPath != null
                ? DigifyAsset(assetPath: iconPath, width: 20.sp, height: 20.sp, color: const Color(0xFF64748B))
                : Icon(iconData, size: 20.sp, color: const Color(0xFF64748B)),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF364153)),
          ),
        ],
      ),
    );
  }
}
