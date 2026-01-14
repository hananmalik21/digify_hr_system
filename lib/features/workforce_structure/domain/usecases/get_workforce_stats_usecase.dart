import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/workforce_stats_repository.dart';

class GetWorkforceStatsUseCase {
  final WorkforceStatsRepository repository;

  const GetWorkforceStatsUseCase({required this.repository});

  Future<WorkforceStats> call() async {
    return await repository.getWorkforceStats();
  }
}
