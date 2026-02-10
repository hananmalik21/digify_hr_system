import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/localization/locale_provider.dart';
import 'package:digify_hr_system/core/navigation/sidebar_provider.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_provider.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'header_left_section.dart';
import 'header_right_section.dart';
import 'header_welcome_section.dart';

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
      color: Colors.transparent,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          boxShadow: AppShadows.headerShadow(isDark),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderLeftSection(
                isMobile: isMobile,
                isDark: isDark,
                onMenuTap: () {
                  if (isMobile) {
                    Scaffold.of(context).openDrawer();
                  } else {
                    ref.read(sidebarProvider.notifier).toggle();
                  }
                },
              ),
              if (!isMobile)
                Expanded(
                  child: HeaderWelcomeSection(localizations: localizations, isTablet: isTablet, isDark: isDark),
                ),
              HeaderRightSection(
                isMobile: isMobile,
                isDark: isDark,
                themeMode: themeMode,
                locale: locale,
                localizations: localizations,
                onToggleTheme: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                onToggleLocale: () => ref.read(localeProvider.notifier).toggleLocale(),
                onGoHome: () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
