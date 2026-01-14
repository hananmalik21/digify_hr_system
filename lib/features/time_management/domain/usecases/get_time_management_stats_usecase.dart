import 'package:digify_hr_system/features/time_management/domain/models/time_management_stats.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/time_management_stats_repository.dart';

class GetTimeManagementStatsUseCase {
  final TimeManagementStatsRepository repository;

  const GetTimeManagementStatsUseCase({required this.repository});

  Future<TimeManagementStats> call() async {
    return await repository.getTimeManagementStats();
  }
}
