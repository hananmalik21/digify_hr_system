import 'package:digify_hr_system/core/enums/time_management_enums.dart';

class TimeManagementTabManager {
  static TimeManagementTab getTabFromRoute(String? routeTab) {
    if (routeTab == null) return TimeManagementTab.shifts;

    switch (routeTab) {
      case 'shifts':
        return TimeManagementTab.shifts;
      case 'work-patterns':
        return TimeManagementTab.workPatterns;
      case 'work-schedules':
        return TimeManagementTab.workSchedules;
      case 'schedule-assignments':
        return TimeManagementTab.scheduleAssignments;
      case 'view-calendar':
        return TimeManagementTab.viewCalendar;
      case 'public-holidays':
        return TimeManagementTab.publicHolidays;
      default:
        return TimeManagementTab.shifts;
    }
  }

  static String getRouteFromTab(TimeManagementTab tab) {
    switch (tab) {
      case TimeManagementTab.shifts:
        return 'shifts';
      case TimeManagementTab.workPatterns:
        return 'work-patterns';
      case TimeManagementTab.workSchedules:
        return 'work-schedules';
      case TimeManagementTab.scheduleAssignments:
        return 'schedule-assignments';
      case TimeManagementTab.viewCalendar:
        return 'view-calendar';
      case TimeManagementTab.publicHolidays:
        return 'public-holidays';
    }
  }
}
