import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/attendance_leaves_card.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_background.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_buttons_helper.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_module_grid.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/floating_eye_icon.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/tasks_events_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;
    final showCards = ref.watch(cardsVisibilityProvider);
    final buttons = getDashboardButtons(localizations);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            DashboardBackground(isDark: isDark),

            // ✅ RESPONSIVE LAYOUT
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

                // right-side cards width for web
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
                                  // grid
                                  Expanded(
                                    child: DashboardModuleGrid(
                                      buttons: buttons,
                                    ),
                                  ),
                                  SizedBox(width: 14.w),

                                  // cards
                                  if (showCards)
                                    SizedBox(
                                      width: sideWidth,
                                      child: Column(
                                        children: [
                                          TasksEventsCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref
                                                .read(
                                                  cardsVisibilityProvider
                                                      .notifier,
                                                )
                                                .toggle(),
                                          ),
                                          SizedBox(height: 14.h),
                                          AttendanceLeavesCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref
                                                .read(
                                                  cardsVisibilityProvider
                                                      .notifier,
                                                )
                                                .toggle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DashboardModuleGrid(buttons: buttons),
                                  SizedBox(height: 14.h),

                                  // tablet: show two cards side-by-side
                                  if (isTablet && showCards)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TasksEventsCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref
                                                .read(
                                                  cardsVisibilityProvider
                                                      .notifier,
                                                )
                                                .toggle(),
                                          ),
                                        ),
                                        SizedBox(width: 14.w),
                                        Expanded(
                                          child: AttendanceLeavesCard(
                                            localizations: localizations,
                                            onEyeIconTap: () => ref
                                                .read(
                                                  cardsVisibilityProvider
                                                      .notifier,
                                                )
                                                .toggle(),
                                          ),
                                        ),
                                      ],
                                    )
                                  else if (showCards) ...[
                                    // mobile: stack cards
                                    TasksEventsCard(
                                      localizations: localizations,
                                      onEyeIconTap: () => ref
                                          .read(
                                            cardsVisibilityProvider.notifier,
                                          )
                                          .toggle(),
                                    ),
                                    SizedBox(height: 14.h),
                                    AttendanceLeavesCard(
                                      localizations: localizations,
                                      onEyeIconTap: () => ref
                                          .read(
                                            cardsVisibilityProvider.notifier,
                                          )
                                          .toggle(),
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

            // Floating eye icon (shown when cards are hidden) - placed last so it's on top
            if (!showCards)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: const FloatingEyeIcon(),
              ),
          ],
        ),
      ),
    );
  }
}
