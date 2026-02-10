import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HeaderRightSection extends StatelessWidget {
  const HeaderRightSection({
    super.key,
    required this.isMobile,
    required this.isDark,
    required this.themeMode,
    required this.locale,
    required this.localizations,
    required this.onToggleTheme,
    required this.onToggleLocale,
    required this.onGoHome,
  });

  final bool isMobile;
  final bool isDark;
  final ThemeMode themeMode;
  final Locale locale;
  final AppLocalizations localizations;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onToggleTheme,
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
        if (!isMobile) Gap(8.w),
        if (!isMobile)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggleLocale,
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
        if (!isMobile) Gap(8.w),
        if (!isMobile)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onGoHome,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
              child: const Icon(Icons.home_outlined, size: 20, color: Color(0xFF1E2939)),
            ),
          ),
        if (!isMobile) Gap(8.w),
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
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: isMobile ? 18.sp : 20.sp,
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
        if (!isMobile) Gap(8.w),
        Theme(
          data: Theme.of(context).copyWith(
            popupMenuTheme: PopupMenuThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              textStyle: TextStyle(color: const Color(0xFF364153), fontSize: 14.sp, fontWeight: FontWeight.w400),
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
            onOpened: () => debugPrint('Popup opened'),
            onCanceled: () => debugPrint('Popup canceled'),
            onSelected: (value) {
              debugPrint('Selected: $value');
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
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
                      Gap(12.w),
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
                            Gap(4.h),
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
              _buildMenuItem(value: 'desktop_tabs', label: 'Manage Desktop Tabs', iconData: Icons.folder_open_outlined),
              _buildMenuItem(value: 'system_settings', label: 'System Settings', iconData: Icons.dns_outlined),
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
                    Gap(12.w),
                    Text(
                      localizations.logout,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFFEF4444)),
                    ),
                  ],
                ),
              ),
            ],
            child: Padding(
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
                      Gap(8.w),
                      Text(
                        localizations.adminUser,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF364153),
                          height: 24 / 15.3,
                        ),
                      ),
                      Gap(8.w),
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
          Gap(12.w),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF364153)),
          ),
        ],
      ),
    );
  }
}
