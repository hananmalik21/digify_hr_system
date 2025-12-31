/// Domain model for Time statistics/analytics
class TimeStatistics {
  final int totalEmployees;
  final int presentToday;
  final int absentToday;
  final int lateToday;
  final int onLeaveToday;
  final double averageHoursToday;
  final double averageHoursThisWeek;
  final double averageHoursThisMonth;
  final int pendingTimeOffRequests;
  final int pendingOvertimeRequests;
  final List<DailyAttendanceStats> weeklyStats;
  final List<DepartmentTimeStats> departmentStats;

  const TimeStatistics({
    required this.totalEmployees,
    required this.presentToday,
    required this.absentToday,
    required this.lateToday,
    required this.onLeaveToday,
    required this.averageHoursToday,
    required this.averageHoursThisWeek,
    required this.averageHoursThisMonth,
    required this.pendingTimeOffRequests,
    required this.pendingOvertimeRequests,
    required this.weeklyStats,
    required this.departmentStats,
  });
}

/// Daily attendance statistics
class DailyAttendanceStats {
  final DateTime date;
  final int present;
  final int absent;
  final int late;
  final int onLeave;
  final double averageHours;

  const DailyAttendanceStats({
    required this.date,
    required this.present,
    required this.absent,
    required this.late,
    required this.onLeave,
    required this.averageHours,
  });
}

/// Department time statistics
class DepartmentTimeStats {
  final String departmentName;
  final int totalEmployees;
  final int present;
  final int absent;
  final double averageHours;
  final double attendanceRate;

  const DepartmentTimeStats({
    required this.departmentName,
    required this.totalEmployees,
    required this.present,
    required this.absent,
    required this.averageHours,
    required this.attendanceRate,
  });
}
