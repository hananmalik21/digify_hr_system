import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_stats_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_tab_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/utils/time_management_tab_manager.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_header.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_stats_cards.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_tab_bar.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/shifts_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/work_patterns_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/work_schedules_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/view_calendar/view_calendar_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/public_holidays_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TimeManagementScreen extends ConsumerStatefulWidget {
  final String? initialTab;

  const TimeManagementScreen({super.key, this.initialTab});

  @override
  ConsumerState<TimeManagementScreen> createState() =>
      _TimeManagementScreenState();
}

class _TimeManagementScreenState extends ConsumerState<TimeManagementScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(timeManagementTabStateProvider.notifier)
            .setTabFromRoute(widget.initialTab);
      });
    }

    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final selectedTab = ref.watch(
      timeManagementTabStateProvider.select((s) => s.currentTab),
    );
    final stats = ref.watch(timeManagementStatsProvider);

    // Get tab label for tab bar
    final tabLabel = _getTabLabel(selectedTab);

    return Container(
      color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh logic can be added here when providers are implemented
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsetsDirectional.only(
              top: 88.h,
              start: 32.w,
              end: 32.w,
              bottom: 24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TimeManagementHeader(localizations: localizations),
                SizedBox(height: 24.h),
                TimeManagementStatsCards(
                  localizations: localizations,
                  stats: stats,
                  isDark: isDark,
                ),
                SizedBox(height: 24.h),
                TimeManagementTabBar(
                  localizations: localizations,
                  selectedTab: tabLabel,
                  onTabSelected: (label) {
                    final tab = _getTabFromLabel(label);
                    ref
                        .read(timeManagementTabStateProvider.notifier)
                        .setTab(tab);
                    final route = TimeManagementTabManager.getRouteFromTab(tab);
                    context.go('${AppRoutes.timeManagement}/$route');
                  },
                  isDark: isDark,
                ),
                SizedBox(height: 24.h),
                _buildTabContent(selectedTab),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(TimeManagementTab selectedTab) {
    switch (selectedTab) {
      case TimeManagementTab.shifts:
        return const ShiftsTab();
      case TimeManagementTab.workPatterns:
        return const WorkPatternsTab();
      case TimeManagementTab.workSchedules:
        return const WorkSchedulesTab();
      case TimeManagementTab.scheduleAssignments:
        return const ScheduleAssignmentsTab();
      case TimeManagementTab.viewCalendar:
        return const ViewCalendarTab();
      case TimeManagementTab.publicHolidays:
        return const PublicHolidaysTab();
    }
  }

  String _getTabLabel(TimeManagementTab tab) {
    switch (tab) {
      case TimeManagementTab.shifts:
        return 'Shifts';
      case TimeManagementTab.workPatterns:
        return 'Work Patterns';
      case TimeManagementTab.workSchedules:
        return 'Work Schedules';
      case TimeManagementTab.scheduleAssignments:
        return 'Schedule Assignments';
      case TimeManagementTab.viewCalendar:
        return 'View Calendar';
      case TimeManagementTab.publicHolidays:
        return 'Public Holidays';
    }
  }

  TimeManagementTab _getTabFromLabel(String label) {
    switch (label) {
      case 'Shifts':
        return TimeManagementTab.shifts;
      case 'Work Patterns':
        return TimeManagementTab.workPatterns;
      case 'Work Schedules':
        return TimeManagementTab.workSchedules;
      case 'Schedule Assignments':
        return TimeManagementTab.scheduleAssignments;
      case 'View Calendar':
        return TimeManagementTab.viewCalendar;
      case 'Public Holidays':
        return TimeManagementTab.publicHolidays;
      default:
        return TimeManagementTab.shifts;
    }
  }
}
