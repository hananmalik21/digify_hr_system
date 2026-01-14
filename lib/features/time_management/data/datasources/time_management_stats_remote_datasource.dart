import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/dto/time_management_stats_dto.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_management_stats.dart';

abstract class TimeManagementStatsRemoteDataSource {
  Future<TimeManagementStats> getTimeManagementStats();
}

class TimeManagementStatsRemoteDataSourceImpl implements TimeManagementStatsRemoteDataSource {
  final ApiClient apiClient;

  const TimeManagementStatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TimeManagementStats> getTimeManagementStats() async {
    try {
      final response = await apiClient.get(ApiEndpoints.tmStats);

      final dto = TimeManagementStatsDto.fromJson(response['data'] as Map<String, dynamic>);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch time management stats: ${e.toString()}', originalError: e);
    }
  }
}
