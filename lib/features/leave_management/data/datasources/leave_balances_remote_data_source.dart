import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/leave_balance_summary_dto.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_balances_dto.dart';

abstract class LeaveBalancesRemoteDataSource {
  Future<PaginatedLeaveBalancesDto> getLeaveBalances({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? employeeGuid,
  });

  Future<LeaveBalanceSummaryResponseDto> getLeaveBalanceSummaries({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? search,
  });

  Future<Map<String, dynamic>> updateLeaveBalance(
    String employeeLeaveBalanceGuid,
    Map<String, dynamic> body, {
    int? tenantId,
  });

  Future<Map<String, dynamic>> adjustLeaveBalances(Map<String, dynamic> body, {int? tenantId});
}

class LeaveBalancesRemoteDataSourceImpl implements LeaveBalancesRemoteDataSource {
  final ApiClient apiClient;

  LeaveBalancesRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders({int? tenantId}) {
    return {if (tenantId != null) 'x-tenant-id': tenantId.toString(), 'x-user-id': 'admin'};
  }

  @override
  Future<PaginatedLeaveBalancesDto> getLeaveBalances({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? employeeGuid,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (employeeGuid != null && employeeGuid.isNotEmpty) 'employee_guid': employeeGuid,
      };

      final response = await apiClient.get(
        ApiEndpoints.absLeaveBalances,
        queryParameters: queryParameters,
        headers: _buildHeaders(tenantId: tenantId),
      );

      return PaginatedLeaveBalancesDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave balances: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<LeaveBalanceSummaryResponseDto> getLeaveBalanceSummaries({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? search,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      };
      final response = await apiClient.get(
        ApiEndpoints.absLeaveBalances,
        queryParameters: queryParameters,
        headers: _buildHeaders(tenantId: tenantId),
      );
      return LeaveBalanceSummaryResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave balance summaries: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateLeaveBalance(
    String employeeLeaveBalanceGuid,
    Map<String, dynamic> body, {
    int? tenantId,
  }) async {
    try {
      return await apiClient.put(
        ApiEndpoints.absLeaveBalanceUpdate(employeeLeaveBalanceGuid),
        body: body,
        headers: _buildHeaders(tenantId: tenantId),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update leave balance: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> adjustLeaveBalances(Map<String, dynamic> body, {int? tenantId}) async {
    try {
      return await apiClient.post(
        ApiEndpoints.absLeaveBalancesAdjust,
        body: body,
        headers: _buildHeaders(tenantId: tenantId),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to adjust leave balances: ${e.toString()}', originalError: e);
    }
  }
}
