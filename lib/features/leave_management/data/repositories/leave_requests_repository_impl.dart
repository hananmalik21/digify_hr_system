import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_requests_local_data_source.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';

/// Implementation of LeaveRequestsRepository
class LeaveRequestsRepositoryImpl implements LeaveRequestsRepository {
  final LeaveRequestsLocalDataSource localDataSource;

  LeaveRequestsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TimeOffRequest>> getLeaveRequests() async {
    try {
      return localDataSource.getLeaveRequests();
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave requests: ${e.toString()}', originalError: e);
    }
  }
}
