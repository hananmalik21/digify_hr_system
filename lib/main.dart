import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/localization/locale_provider.dart';
import 'package:digify_hr_system/core/router/app_router.dart';
import 'package:digify_hr_system/core/theme/app_theme.dart';
import 'package:digify_hr_system/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ProviderScope(child: DigifyHrSystemApp()));
}

class DigifyHrSystemApp extends ConsumerWidget {
  const DigifyHrSystemApp({super.key});

  Size _getDesignSize(double width) {
    if (width >= 1200) {
      // Web / Desktop
      return const Size(1440, 900);
    } else if (width >= 768) {
      // Tablet
      return const Size(768, 1024);
    } else {
      // Mobile
      return const Size(375, 812);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final designSize = _getDesignSize(constraints.maxWidth);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'Digify HR System',
              debugShowCheckedModeBanner: false,
              locale: locale,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}
