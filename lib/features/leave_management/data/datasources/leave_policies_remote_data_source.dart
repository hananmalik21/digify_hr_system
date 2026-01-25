import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/leave_policies_dto.dart';

abstract class LeavePoliciesRemoteDataSource {
  Future<LeavePoliciesResponseDto> getLeavePolicies({int? tenantId, String? status, String? kuwaitLaborCompliant});
}

class LeavePoliciesRemoteDataSourceImpl implements LeavePoliciesRemoteDataSource {
  final ApiClient apiClient;

  LeavePoliciesRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders({int? tenantId}) {
    return {if (tenantId != null) 'x-tenant-id': tenantId.toString(), 'x-user-id': 'admin'};
  }

  @override
  Future<LeavePoliciesResponseDto> getLeavePolicies({
    int? tenantId,
    String? status,
    String? kuwaitLaborCompliant,
  }) async {
    try {
      final queryParameters = <String, String>{};
      if (tenantId != null) queryParameters['tenant_id'] = tenantId.toString();
      if (status != null && status.isNotEmpty) queryParameters['status'] = status;
      if (kuwaitLaborCompliant != null && kuwaitLaborCompliant.isNotEmpty) {
        queryParameters['kuwait_labor_compliant'] = kuwaitLaborCompliant;
      }

      final response = await apiClient.get(
        ApiEndpoints.absLeavePolicies,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
        headers: _buildHeaders(tenantId: tenantId),
      );

      return LeavePoliciesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave policies: ${e.toString()}', originalError: e);
    }
  }
}
