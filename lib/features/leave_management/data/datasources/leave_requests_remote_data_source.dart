import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';

abstract class LeaveRequestsRemoteDataSource {
  Future<PaginatedLeaveRequestsDto> getLeaveRequests({int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> approveLeaveRequest(String guid);

  Future<Map<String, dynamic>> rejectLeaveRequest(String guid);
}

class LeaveRequestsRemoteDataSourceImpl implements LeaveRequestsRemoteDataSource {
  final ApiClient apiClient;

  static const Map<String, String> _absHeaders = {'x-tenant-id': '1001', 'x-user-id': 'admin'};

  LeaveRequestsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedLeaveRequestsDto> getLeaveRequests({int page = 1, int pageSize = 10}) async {
    try {
      final queryParameters = <String, String>{'page': page.toString(), 'page_size': pageSize.toString()};

      final response = await apiClient.get(ApiEndpoints.absLeaveRequests, queryParameters: queryParameters);

      return PaginatedLeaveRequestsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave requests: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> approveLeaveRequest(String guid) async {
    try {
      final response = await apiClient.post(ApiEndpoints.absLeaveRequestApprove(guid), headers: _absHeaders);

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to approve leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectLeaveRequest(String guid) async {
    try {
      final response = await apiClient.post(ApiEndpoints.absLeaveRequestReject(guid), headers: _absHeaders);

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject leave request: ${e.toString()}', originalError: e);
    }
  }
}
