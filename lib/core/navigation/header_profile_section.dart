import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HeaderProfileSection extends StatelessWidget {
  final bool isDark;
  final bool isMobile;
  final AppLocalizations localizations;

  const HeaderProfileSection({super.key, required this.isDark, required this.isMobile, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Theme(
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
          _buildMenuItem(value: 'profile', label: 'My Profile', iconPath: 'assets/icons/user_icon.svg', isSvg: true),
          _buildMenuItem(value: 'desktop_tabs', label: 'Manage Desktop Tabs', iconData: Icons.folder_open_outlined),
          _buildMenuItem(value: 'system_settings', label: 'System Settings', iconData: Icons.dns_outlined),
          _buildMenuItem(value: 'settings', label: 'Settings', iconPath: 'assets/icons/settings_icon.svg', isSvg: true),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container matching image
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10.r)),
              alignment: Alignment.center,
              child: DigifyAsset(
                assetPath: Assets.icons.employeeManagement.user.path,
                width: 18.w,
                height: 18.h,
                color: AppColors.cardBackground,
              ),
            ),
            if (!isMobile) ...[
              Gap(7.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'System Administrator',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'System Admin',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontSize: 10.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
                    ),
                  ),
                ],
              ),
              Gap(12.w),
              DigifyAsset(
                assetPath: Assets.icons.header.chevronDown.path,
                height: 14.sp,
                width: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              ),
            ],
          ],
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
