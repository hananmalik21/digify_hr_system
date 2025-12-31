import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mock stats for time management dashboard
class TimeManagementStats {
  final int totalShifts;
  final int workPatterns;
  final int activeSchedules;
  final int assignments;

  const TimeManagementStats({
    this.totalShifts = 4,
    this.workPatterns = 3,
    this.activeSchedules = 2,
    this.assignments = 5,
  });
}

/// Provider for time management stats
final timeManagementStatsProvider = Provider<TimeManagementStats>((ref) {
  return const TimeManagementStats();
});
