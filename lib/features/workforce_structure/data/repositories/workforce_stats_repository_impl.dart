import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/workforce_stats_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/workforce_stats_repository.dart';

class WorkforceStatsRepositoryImpl implements WorkforceStatsRepository {
  final WorkforceStatsRemoteDataSource remoteDataSource;

  const WorkforceStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WorkforceStats> getWorkforceStats() async {
    try {
      return await remoteDataSource.getWorkforceStats();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
