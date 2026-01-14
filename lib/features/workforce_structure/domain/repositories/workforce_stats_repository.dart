import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';

abstract class WorkforceStatsRepository {
  Future<WorkforceStats> getWorkforceStats();
}
