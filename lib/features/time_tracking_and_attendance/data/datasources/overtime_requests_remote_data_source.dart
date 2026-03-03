import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/data/dto/overtime_requests_dto.dart';

abstract class OvertimeRequestsRemoteDataSource {
  Future<OvertimeRequestsResponseDto> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  });
}

class OvertimeRequestsRemoteDataSourceImpl implements OvertimeRequestsRemoteDataSource {
  final ApiClient apiClient;

  OvertimeRequestsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OvertimeRequestsResponseDto> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }
      if (orgUnitId != null && orgUnitId.isNotEmpty) {
        queryParameters['org_unit_id'] = orgUnitId;
      }
      if (levelCode != null && levelCode.isNotEmpty) {
        queryParameters['level_code'] = levelCode;
      }

      final response = await apiClient.get(ApiEndpoints.tmOvertimeRequests, queryParameters: queryParameters);

      return OvertimeRequestsResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch overtime requests: ${e.toString()}', originalError: e);
    }
  }
}
