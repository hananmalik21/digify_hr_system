import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/workforce_structure/data/dtos/workforce_stats_dto.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';

abstract class WorkforceStatsRemoteDataSource {
  Future<WorkforceStats> getWorkforceStats();
}

class WorkforceStatsRemoteDataSourceImpl implements WorkforceStatsRemoteDataSource {
  final ApiClient apiClient;

  const WorkforceStatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WorkforceStats> getWorkforceStats() async {
    try {
      final response = await apiClient.get(ApiEndpoints.workforceStats);

      final dto = WorkforceStatsDto.fromJson(response['data'] as Map<String, dynamic>);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch workforce stats: ${e.toString()}', originalError: e);
    }
  }
}
