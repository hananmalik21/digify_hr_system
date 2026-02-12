import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/attendance_leaves_card.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_background.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_buttons_helper.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_module_grid.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/floating_eye_icon.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/tasks_events_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleModuleTap(DashboardButton btn) {
    if (btn.id == 'dashboard') {
      context.go(btn.route);
      return;
    }

    final sidebarItems = SidebarConfig.getMenuItems();
    SidebarItem? match;

    try {
      match = sidebarItems.firstWhere((item) => item.id == btn.id);
    } catch (_) {
      final camelId = _kebabToCamel(btn.id);
      try {
        match = sidebarItems.firstWhere((item) => item.id == camelId);
      } catch (_) {
        if (btn.id == 'settings') {
          try {
            match = sidebarItems.firstWhere((item) => item.id == 'settingsConfig');
          } catch (_) {}
        }
      }
    }

    if (match != null && match.children != null && match.children!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => ModuleSelectionDialog(module: match!, parentColor: btn.color),
      );
    } else {
      context.go(btn.route);
    }
  }

  String _kebabToCamel(String input) {
    if (!input.contains('-')) return input;
    final parts = input.split('-');
    final buffer = StringBuffer(parts[0]);
    for (var i = 1; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        buffer.write(part[0].toUpperCase() + part.substring(1));
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final showCards = ref.watch(cardsVisibilityProvider);
    final buttons = getDashboardButtons(localizations);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            DashboardBackground(isDark: isDark),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;

                final isMobile = w < 600;
                final isTablet = w >= 600 && w < 1024;
                final isWeb = w >= 1024;

                final pagePadding = EdgeInsetsDirectional.only(
                  top: isMobile ? 20.h : 45.5.h,
                  start: isMobile ? 12.w : 14.w,
                  end: isMobile ? 12.w : 21.w,
                  bottom: 14.h,
                );

                final sideWidth = (w * 0.22).clamp(260.0, 340.0).toDouble();

                return SingleChildScrollView(
                  child: Padding(
                    padding: pagePadding,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1800),
                        child: isWeb
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: DashboardModuleGrid(buttons: buttons, onButtonTap: _handleModuleTap),
                                  ),
                                  SizedBox(width: 14.w),

                                  if (showCards)
                                    SizedBox(
                                      width: sideWidth,
                                      child: Column(
                                        children: [
                                          TasksEventsCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
                                          ),
                                          SizedBox(height: 14.h),
                                          AttendanceLeavesCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DashboardModuleGrid(buttons: buttons, onButtonTap: _handleModuleTap),
                                  SizedBox(height: 14.h),

                                  if (isTablet && showCards)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TasksEventsCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
                                          ),
                                        ),
                                        SizedBox(width: 14.w),
                                        Expanded(
                                          child: AttendanceLeavesCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
                                          ),
                                        ),
                                      ],
                                    )
                                  else if (showCards) ...[
                                    TasksEventsCard(
                                      localizations: localizations,
                                      onEyeIconTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
                                    ),
                                    SizedBox(height: 14.h),
                                    AttendanceLeavesCard(
                                      localizations: localizations,
                                      onEyeIconTap: () => ref.read(cardsVisibilityProvider.notifier).toggle(),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),

            if (!showCards) Positioned(top: 12.h, right: 12.w, child: const FloatingEyeIcon()),
          ],
        ),
      ),
    );
  }
}
