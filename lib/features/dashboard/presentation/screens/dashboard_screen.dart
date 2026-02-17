import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/attendance_leaves_card.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_background.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_buttons_helper.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_module_grid.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/tasks_events_card.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
      context.go(AppRoutes.dashboardModuleSelectionPath(btn.id));
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
    final buttons = getDashboardButtons(localizations);

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: DigifyAsset(
          assetPath: Assets.icons.manageEnterpriseIcon.path,
          width: 20.w,
          height: 20.h,
          color: AppColors.cardBackground,
        ),
      ),
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

                final sideWidth = (w * 0.15).clamp(200.0, 250.0).toDouble();

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
                                  Gap(14.w),
                                  SizedBox(
                                    width: sideWidth,
                                    child: Column(
                                      children: [
                                        TasksEventsCard(localizations: localizations),
                                        Gap(14.h),
                                        AttendanceLeavesCard(localizations: localizations),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DashboardModuleGrid(buttons: buttons, onButtonTap: _handleModuleTap),
                                  Gap(14.h),
                                  if (isTablet)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: TasksEventsCard(localizations: localizations)),
                                        Gap(14.w),
                                        Expanded(child: AttendanceLeavesCard(localizations: localizations)),
                                      ],
                                    )
                                  else ...[
                                    TasksEventsCard(localizations: localizations),
                                    Gap(14.h),
                                    AttendanceLeavesCard(localizations: localizations),
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
