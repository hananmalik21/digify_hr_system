import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';

/// Repository interface for leave requests operations
abstract class LeaveRequestsRepository {
  Future<List<TimeOffRequest>> getLeaveRequests();
}
