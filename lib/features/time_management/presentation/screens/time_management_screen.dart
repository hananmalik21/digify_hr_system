import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/common/digify_tab_header.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_tab_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_header_actions.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_tab_config.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_tab_with_enterprise_selector.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_stats_cards.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/shifts/shifts_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_patterns/work_patterns_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/work_schedules_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/view_calendar/view_calendar_tab.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/public_holidays_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TimeManagementScreen extends ConsumerStatefulWidget {
  const TimeManagementScreen({super.key});

  @override
  ConsumerState<TimeManagementScreen> createState() => _TimeManagementScreenState();
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
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(timeManagementTabStateProvider.select((s) => s.currentTabIndex));
    final tabs = TimeManagementTab.values;
    final currentTab = (currentTabIndex >= 0 && currentTabIndex < tabs.length)
        ? tabs[currentTabIndex]
        : TimeManagementTab.shifts;
    final headerTitle = currentTab.label(localizations);
    final Widget? headerTrailing = TimeManagementHeaderActions.getTrailingAction(context, currentTab);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 47.h, bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            DigifyTabHeader(title: headerTitle, trailing: headerTrailing),
            Gap(24.h),
            TimeManagementStatsCards(localizations: localizations, isDark: isDark),
            Gap(24.h),
            _buildTabContent(currentTabIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return TimeManagementTabWithEnterpriseSelector(tab: TimeManagementTab.shifts, child: const ShiftsTab());
      case 1:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.workPatterns,
          child: const WorkPatternsTab(),
        );
      case 2:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.workSchedules,
          child: const WorkSchedulesTab(),
        );
      case 3:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.scheduleAssignments,
          child: const ScheduleAssignmentsTab(),
        );
      case 4:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.viewCalendar,
          child: const ViewCalendarTab(),
        );
      case 5:
        return TimeManagementTabWithEnterpriseSelector(
          tab: TimeManagementTab.publicHolidays,
          child: const PublicHolidaysTab(),
        );
      default:
        return TimeManagementTabWithEnterpriseSelector(tab: TimeManagementTab.shifts, child: const ShiftsTab());
    }
  }
}
