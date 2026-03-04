import 'package:digify_hr_system/core/widgets/common/enterprise_selector_widget.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/schedule_assignments_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_enterprise_id_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/view_calendar_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedules_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/common/time_management_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TimeManagementTabWithEnterpriseSelector extends ConsumerWidget {
  const TimeManagementTabWithEnterpriseSelector({super.key, required this.tab, required this.child});

  final TimeManagementTab tab;
  final Widget child;

  void _onEnterpriseChanged(WidgetRef ref, TimeManagementTab tab, int? enterpriseId) {
    switch (tab) {
      case TimeManagementTab.shifts:
        ref.read(shiftsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
      case TimeManagementTab.workPatterns:
        ref.read(workPatternsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
      case TimeManagementTab.workSchedules:
        ref.read(workSchedulesTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
      case TimeManagementTab.scheduleAssignments:
        ref.read(scheduleAssignmentsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
      case TimeManagementTab.viewCalendar:
        ref.read(viewCalendarTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
      case TimeManagementTab.publicHolidays:
        ref.read(publicHolidaysTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveEnterpriseId = switch (tab) {
      TimeManagementTab.shifts => ref.watch(shiftsTabEnterpriseIdProvider),
      TimeManagementTab.workPatterns => ref.watch(workPatternsTabEnterpriseIdProvider),
      TimeManagementTab.workSchedules => ref.watch(workSchedulesTabEnterpriseIdProvider),
      TimeManagementTab.scheduleAssignments => ref.watch(scheduleAssignmentsTabEnterpriseIdProvider),
      TimeManagementTab.viewCalendar => ref.watch(viewCalendarTabEnterpriseIdProvider),
      TimeManagementTab.publicHolidays => ref.watch(publicHolidaysTabEnterpriseIdProvider),
    };

    return ProviderScope(
      overrides: [
        timeManagementEnterpriseIdProvider.overrideWith(
          (ref) => switch (tab) {
            TimeManagementTab.shifts => ref.watch(shiftsTabEnterpriseIdProvider),
            TimeManagementTab.workPatterns => ref.watch(workPatternsTabEnterpriseIdProvider),
            TimeManagementTab.workSchedules => ref.watch(workSchedulesTabEnterpriseIdProvider),
            TimeManagementTab.scheduleAssignments => ref.watch(scheduleAssignmentsTabEnterpriseIdProvider),
            TimeManagementTab.viewCalendar => ref.watch(viewCalendarTabEnterpriseIdProvider),
            TimeManagementTab.publicHolidays => ref.watch(publicHolidaysTabEnterpriseIdProvider),
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) => _onEnterpriseChanged(ref, tab, enterpriseId),
            subtitle: effectiveEnterpriseId != null
                ? 'Viewing data for selected enterprise'
                : 'Select an enterprise to view data',
          ),
          Gap(24.h),
          child,
        ],
      ),
    );
  }
}
