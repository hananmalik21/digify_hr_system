import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/navigation/header_notification_icon.dart';
import 'package:digify_hr_system/core/navigation/header_profile_section.dart';
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
        // Language Selector
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggleLocale,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.header.language.path,
                    width: 30.sp,
                    height: 30.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
                  ),
                  Gap(8.w),
                  Text(
                    locale.languageCode.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Gap(16.w),
        // Home Icon
        DigifyAssetButton(
          onTap: onGoHome,
          assetPath: Assets.icons.homeIcon.path,
          width: 30.sp,
          height: 30.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
        ),
        Gap(16.w),
        // Help Icon
        DigifyAssetButton(
          onTap: () {},
          assetPath: Assets.icons.header.help.path,
          width: 30.sp,
          height: 30.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
        ),
        Gap(16.w),
        // Notifications
        HeaderNotificationIcon(count: 2, isDark: isDark, onTap: () {}),
        // Divider
        DigifyVerticalDivider.standard(
          thickness: 2,
          margin: EdgeInsets.symmetric(vertical: 13.h, horizontal: 14.w),
        ),
        // Profile Section
        HeaderProfileSection(isDark: isDark, isMobile: isMobile, localizations: localizations),
      ],
    );
  }
}
