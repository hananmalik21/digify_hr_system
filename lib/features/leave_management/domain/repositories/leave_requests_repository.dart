import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';

abstract class LeaveRequestsRepository {
  Future<PaginatedLeaveRequests> getLeaveRequests({int page = 1, int pageSize = 10, String? status, int? tenantId});

  Future<Map<String, dynamic>> getLeaveRequestById(String guid, {int? tenantId});

  Future<Map<String, dynamic>> approveLeaveRequest(String guid, {int? tenantId});

  Future<Map<String, dynamic>> rejectLeaveRequest(String guid, {int? tenantId});

  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit, {int? tenantId});

  Future<Map<String, dynamic>> deleteLeaveRequest(String guid, {int? tenantId});

  Future<Map<String, dynamic>> updateLeaveRequest(
    String guid,
    NewLeaveRequestState state,
    bool submit, {
    int? tenantId,
  });
}
