import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/page_header_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_stats_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_tab_provider.dart';
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
    final stats = ref.watch(timeManagementStatsProvider);

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
            padding: EdgeInsetsDirectional.only(top: 88.h, start: 32.w, end: 32.w, bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeaderWidget(
                  localizations: localizations,
                  title: localizations.timeManagement,
                  icon: Assets.icons.timeManagementMainIcon.path,
                ),
                SizedBox(height: 24.h),
                TimeManagementStatsCards(localizations: localizations, stats: stats, isDark: isDark),
                SizedBox(height: 24.h),
                TimeManagementTabBar(
                  localizations: localizations,
                  selectedTabIndex: currentTabIndex,
                  onTabSelected: (index) {
                    ref.read(timeManagementTabStateProvider.notifier).setTabIndex(index);
                  },
                  isDark: isDark,
                ),
                SizedBox(height: 24.h),
                _buildTabContent(currentTabIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const ShiftsTab();
      case 1:
        return const WorkPatternsTab();
      case 2:
        return const WorkSchedulesTab();
      case 3:
        return const ScheduleAssignmentsTab();
      case 4:
        return const ViewCalendarTab();
      case 5:
        return const PublicHolidaysTab();
      default:
        return const ShiftsTab();
    }
  }
}
