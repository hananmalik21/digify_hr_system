import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.themeBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations.dashboard,
              style: context.headlineLarge,
            ),
            SizedBox(height: 16.h),
            Text(
              'Welcome to Digify HR System',
              style: context.bodyMedium.copyWith(
                color: context.themeTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

