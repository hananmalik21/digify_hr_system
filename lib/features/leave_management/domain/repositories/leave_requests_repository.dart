import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';

abstract class LeaveRequestsRepository {
  Future<PaginatedLeaveRequests> getLeaveRequests({int page = 1, int pageSize = 10, String? status});

  Future<Map<String, dynamic>> approveLeaveRequest(String guid);

  Future<Map<String, dynamic>> rejectLeaveRequest(String guid);

  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit);
}
