import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../providers/time_tracking_and_attendance_tab_state_provider.dart';
import 'attendance_screen.dart';
import 'overtime_screen.dart';
import 'timesheet_screen.dart';

class TimeTrackingAndAttendanceScreen extends ConsumerWidget {
  const TimeTrackingAndAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(timeTrackingAndAttendanceTabStateProvider.select((s) => s.currentTabIndex));

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: _buildTabContent(context, currentTabIndex),
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const AttendanceScreen();
      case 1:
        return const TimesheetScreen();
      case 2:
        return const OvertimeScreen();
      default:
        return const SizedBox();
    }
  }
}
