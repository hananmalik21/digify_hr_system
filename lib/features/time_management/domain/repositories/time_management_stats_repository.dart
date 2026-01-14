import 'package:digify_hr_system/features/time_management/domain/models/time_management_stats.dart';

abstract class TimeManagementStatsRepository {
  Future<TimeManagementStats> getTimeManagementStats();
}
