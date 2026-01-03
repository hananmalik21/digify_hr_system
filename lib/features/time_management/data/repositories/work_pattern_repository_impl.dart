import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/work_pattern_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/work_pattern_repository.dart';

class WorkPatternRepositoryImpl implements WorkPatternRepository {
  final WorkPatternRemoteDataSource remoteDataSource;
  final int tenantId;

  const WorkPatternRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedWorkPatterns> getWorkPatterns({int page = 1, int pageSize = 10}) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('pageSize must be between 1 and 100');
      }

      return await remoteDataSource.getWorkPatterns(tenantId: tenantId, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get work patterns: ${e.toString()}', originalError: e);
    }
  }
}
