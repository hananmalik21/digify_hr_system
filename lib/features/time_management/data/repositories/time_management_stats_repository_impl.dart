import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/time_management_stats_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_management_stats.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/time_management_stats_repository.dart';

class TimeManagementStatsRepositoryImpl implements TimeManagementStatsRepository {
  final TimeManagementStatsRemoteDataSource remoteDataSource;

  const TimeManagementStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TimeManagementStats> getTimeManagementStats() async {
    try {
      return await remoteDataSource.getTimeManagementStats();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
