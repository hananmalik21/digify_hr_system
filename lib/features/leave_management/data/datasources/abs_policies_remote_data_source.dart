import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/abs_policies_dto.dart';

abstract class AbsPoliciesRemoteDataSource {
  Future<AbsPoliciesResponseDto> getPolicies({required int tenantId, int page = 1, int pageSize = 10});
}

class AbsPoliciesRemoteDataSourceImpl implements AbsPoliciesRemoteDataSource {
  final ApiClient apiClient;

  AbsPoliciesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AbsPoliciesResponseDto> getPolicies({required int tenantId, int page = 1, int pageSize = 10}) async {
    try {
      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.absPolicies, queryParameters: queryParameters);

      return AbsPoliciesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }
}
