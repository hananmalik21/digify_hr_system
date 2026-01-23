import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';

abstract class LeaveRequestsRepository {
  Future<PaginatedLeaveRequests> getLeaveRequests({int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> approveLeaveRequest(String guid);

  Future<Map<String, dynamic>> rejectLeaveRequest(String guid);
}
