import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_requests_local_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/leave_requests_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for leave requests local data source
final leaveRequestsLocalDataSourceProvider = Provider<LeaveRequestsLocalDataSource>(
  (ref) => LeaveRequestsLocalDataSourceImpl(),
);

/// Provider for leave requests repository
final leaveRequestsRepositoryProvider = Provider<LeaveRequestsRepositoryImpl>(
  (ref) => LeaveRequestsRepositoryImpl(localDataSource: ref.watch(leaveRequestsLocalDataSourceProvider)),
);

/// Provider for leave requests list
final leaveRequestsProvider = FutureProvider<List<TimeOffRequest>>((ref) async {
  final repository = ref.watch(leaveRequestsRepositoryProvider);
  try {
    return await repository.getLeaveRequests();
  } on AppException {
    rethrow;
  } catch (e) {
    throw Exception('Failed to load leave requests: ${e.toString()}');
  }
});

/// Provider for filtered leave requests based on selected filter
final filteredLeaveRequestsProvider = Provider<AsyncValue<List<TimeOffRequest>>>((ref) {
  final requestsAsync = ref.watch(leaveRequestsProvider);
  final filter = ref.watch(leaveFilterProvider);

  return requestsAsync.when(
    data: (requests) {
      final filtered = _filterRequests(requests, filter);
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

List<TimeOffRequest> _filterRequests(List<TimeOffRequest> requests, LeaveFilter filter) {
  if (filter == LeaveFilter.all) {
    return requests;
  }

  final statusMap = {
    LeaveFilter.pending: RequestStatus.pending,
    LeaveFilter.approved: RequestStatus.approved,
    LeaveFilter.rejected: RequestStatus.rejected,
  };

  final targetStatus = statusMap[filter];
  return requests.where((request) => request.status == targetStatus).toList();
}
