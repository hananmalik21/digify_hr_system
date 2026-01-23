import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_requests_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/new_leave_request_provider.dart';

class LeaveRequestsRepositoryImpl implements LeaveRequestsRepository {
  final LeaveRequestsRemoteDataSource remoteDataSource;

  LeaveRequestsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedLeaveRequests> getLeaveRequests({int page = 1, int pageSize = 10, String? status}) async {
    try {
      final dto = await remoteDataSource.getLeaveRequests(page: page, pageSize: pageSize, status: status);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave requests: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> approveLeaveRequest(String guid) async {
    try {
      return await remoteDataSource.approveLeaveRequest(guid);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to approve leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectLeaveRequest(String guid) async {
    try {
      return await remoteDataSource.rejectLeaveRequest(guid);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to reject leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit) async {
    try {
      return await remoteDataSource.createLeaveRequest(state, submit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to create leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteLeaveRequest(String guid) async {
    try {
      return await remoteDataSource.deleteLeaveRequest(guid);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to delete leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateLeaveRequest(String guid, NewLeaveRequestState state, bool submit) async {
    try {
      return await remoteDataSource.updateLeaveRequest(guid, state, submit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to update leave request: ${e.toString()}', originalError: e);
    }
  }
}
