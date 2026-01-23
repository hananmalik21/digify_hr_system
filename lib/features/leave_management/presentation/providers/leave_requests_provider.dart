import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_requests_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/leave_requests_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_actions_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestsState {
  final PaginatedLeaveRequests? data;
  final bool isLoading;
  final String? error;

  const LeaveRequestsState({this.data, this.isLoading = false, this.error});

  LeaveRequestsState copyWith({PaginatedLeaveRequests? data, bool? isLoading, String? error}) {
    return LeaveRequestsState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading, error: error);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leaveRequestsRemoteDataSourceProvider = Provider<LeaveRequestsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaveRequestsRemoteDataSourceImpl(apiClient: apiClient);
});

final leaveRequestsRepositoryProvider = Provider<LeaveRequestsRepository>((ref) {
  final remoteDataSource = ref.watch(leaveRequestsRemoteDataSourceProvider);
  return LeaveRequestsRepositoryImpl(remoteDataSource: remoteDataSource);
});

final leaveRequestsPaginationProvider = StateProvider<({int page, int pageSize})>((ref) {
  return (page: 1, pageSize: 10);
});

class LeaveRequestsNotifier extends StateNotifier<LeaveRequestsState> {
  final LeaveRequestsRepository _repository;
  final Ref _ref;

  LeaveRequestsNotifier(this._repository, this._ref) : super(const LeaveRequestsState(isLoading: true)) {
    _ref.listen(leaveRequestsPaginationProvider, (previous, next) {
      if (previous != next) {
        _loadRequests();
      }
    });
    _ref.listen(leaveFilterProvider, (previous, next) {
      if (previous != next) {
        _loadRequests();
      }
    });
    _loadRequests();
  }

  String? _mapFilterToStatus(LeaveFilter filter) {
    switch (filter) {
      case LeaveFilter.all:
        return null;
      case LeaveFilter.pending:
        return 'SUBMITTED';
      case LeaveFilter.approved:
        return 'APPROVED';
      case LeaveFilter.rejected:
        return 'REJECTED';
    }
  }

  Future<void> _loadRequests() async {
    final pagination = _ref.read(leaveRequestsPaginationProvider);
    final filter = _ref.read(leaveFilterProvider);
    final status = _mapFilterToStatus(filter);

    state = state.copyWith(isLoading: true, error: null);

    try {
      final data = await _repository.getLeaveRequests(
        page: pagination.page,
        pageSize: pagination.pageSize,
        status: status,
      );
      state = state.copyWith(data: data, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load leave requests: ${e.toString()}', isLoading: false);
    }
  }

  Future<void> refresh() async {
    await _loadRequests();
  }

  Future<void> approveLeaveRequest(String guid) async {
    _ref.read(leaveRequestsApproveLoadingProvider.notifier).state = {
      ..._ref.read(leaveRequestsApproveLoadingProvider),
      guid,
    };

    try {
      await _repository.approveLeaveRequest(guid);

      if (state.data != null) {
        final updatedRequests = state.data!.requests.map((request) {
          if (request.guid == guid) {
            return TimeOffRequest(
              id: request.id,
              guid: request.guid,
              employeeId: request.employeeId,
              employeeName: request.employeeName,
              type: request.type,
              startDate: request.startDate,
              endDate: request.endDate,
              totalDays: request.totalDays,
              status: RequestStatus.approved,
              reason: request.reason,
              rejectionReason: request.rejectionReason,
              approvedBy: request.approvedBy,
              approvedByName: request.approvedByName,
              requestedAt: request.requestedAt,
              approvedAt: DateTime.now(),
              rejectedAt: request.rejectedAt,
            );
          }
          return request;
        }).toList();

        state = state.copyWith(
          data: PaginatedLeaveRequests(requests: updatedRequests, pagination: state.data!.pagination),
        );
      }
    } finally {
      final loadingSet = {..._ref.read(leaveRequestsApproveLoadingProvider)};
      loadingSet.remove(guid);
      _ref.read(leaveRequestsApproveLoadingProvider.notifier).state = loadingSet;
    }
  }

  Future<void> rejectLeaveRequest(String guid) async {
    _ref.read(leaveRequestsRejectLoadingProvider.notifier).state = {
      ..._ref.read(leaveRequestsRejectLoadingProvider),
      guid,
    };

    try {
      await _repository.rejectLeaveRequest(guid);

      if (state.data != null) {
        final updatedRequests = state.data!.requests.map((request) {
          if (request.guid == guid) {
            return TimeOffRequest(
              id: request.id,
              guid: request.guid,
              employeeId: request.employeeId,
              employeeName: request.employeeName,
              type: request.type,
              startDate: request.startDate,
              endDate: request.endDate,
              totalDays: request.totalDays,
              status: RequestStatus.rejected,
              reason: request.reason,
              rejectionReason: request.rejectionReason,
              approvedBy: request.approvedBy,
              approvedByName: request.approvedByName,
              requestedAt: request.requestedAt,
              approvedAt: request.approvedAt,
              rejectedAt: DateTime.now(),
            );
          }
          return request;
        }).toList();

        state = state.copyWith(
          data: PaginatedLeaveRequests(requests: updatedRequests, pagination: state.data!.pagination),
        );
      }
    } finally {
      final loadingSet = {..._ref.read(leaveRequestsRejectLoadingProvider)};
      loadingSet.remove(guid);
      _ref.read(leaveRequestsRejectLoadingProvider.notifier).state = loadingSet;
    }
  }

  void addLeaveRequestOptimistically(Map<String, dynamic> responseData, String employeeName, TimeOffType leaveType) {
    final data = responseData['data'] as Map<String, dynamic>?;
    if (data == null) return;

    final leaveRequest = data['leave_request'] as Map<String, dynamic>?;
    final contact = data['contact'] as Map<String, dynamic>?;
    if (leaveRequest == null) return;

    final reason = contact?['reason_for_leave'] as String? ?? '';

    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is num) return value.toDouble();
      return 0.0;
    }

    RequestStatus mapStatus(String? status) {
      switch (status?.toUpperCase()) {
        case 'SUBMITTED':
          return RequestStatus.pending;
        case 'APPROVED':
          return RequestStatus.approved;
        case 'REJECTED':
          return RequestStatus.rejected;
        case 'WITHDRAWN':
        case 'CANCELLED':
          return RequestStatus.cancelled;
        default:
          return RequestStatus.pending;
      }
    }

    final newRequest = TimeOffRequest(
      id: (leaveRequest['leave_request_id'] as num?)?.toInt() ?? 0,
      guid: leaveRequest['leave_request_guid'] as String? ?? '',
      employeeId: (leaveRequest['employee_id'] as num?)?.toInt() ?? 0,
      employeeName: employeeName,
      type: leaveType,
      startDate: parseDateTime(leaveRequest['start_date']),
      endDate: parseDateTime(leaveRequest['end_date']),
      totalDays: parseDouble(leaveRequest['total_days']),
      status: mapStatus(leaveRequest['request_status'] as String?),
      reason: reason,
      rejectionReason: null,
      approvedBy: null,
      approvedByName: null,
      requestedAt: parseDateTime(leaveRequest['submitted_at']),
      approvedAt: parseDateTime(leaveRequest['approved_at']),
      rejectedAt: parseDateTime(leaveRequest['rejected_at']),
    );

    if (state.data != null) {
      final updatedRequests = [newRequest, ...state.data!.requests];
      final currentPagination = state.data!.pagination;
      final updatedPagination = PaginationInfo(
        currentPage: currentPagination.currentPage,
        totalPages: currentPagination.totalPages,
        totalItems: currentPagination.totalItems + 1,
        pageSize: currentPagination.pageSize,
        hasNext: currentPagination.hasNext,
        hasPrevious: currentPagination.hasPrevious,
      );

      state = state.copyWith(
        data: PaginatedLeaveRequests(requests: updatedRequests, pagination: updatedPagination),
      );
    } else {
      final pagination = PaginationInfo(
        currentPage: 1,
        totalPages: 1,
        totalItems: 1,
        pageSize: 10,
        hasNext: false,
        hasPrevious: false,
      );
      state = state.copyWith(
        data: PaginatedLeaveRequests(requests: [newRequest], pagination: pagination),
      );
    }
  }
}

final leaveRequestsNotifierProvider = StateNotifierProvider<LeaveRequestsNotifier, LeaveRequestsState>((ref) {
  final repository = ref.watch(leaveRequestsRepositoryProvider);
  return LeaveRequestsNotifier(repository, ref);
});

final leaveRequestsProvider = Provider<AsyncValue<PaginatedLeaveRequests>>((ref) {
  final state = ref.watch(leaveRequestsNotifierProvider);

  if (state.isLoading) {
    return const AsyncValue.loading();
  }

  if (state.error != null && state.data == null) {
    return AsyncValue.error(Exception(state.error!), StackTrace.current);
  }

  if (state.data != null) {
    return AsyncValue.data(state.data!);
  }

  return const AsyncValue.loading();
});

final filteredLeaveRequestsProvider = Provider<AsyncValue<List<TimeOffRequest>>>((ref) {
  final requestsAsync = ref.watch(leaveRequestsProvider);
  final filter = ref.watch(leaveFilterProvider);

  return requestsAsync.when(
    data: (paginatedResponse) {
      final filtered = _filterRequests(paginatedResponse.requests, filter);
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final leaveRequestsPaginationNotifierProvider = Provider<void Function()>((ref) {
  return () {
    ref.read(leaveRequestsNotifierProvider.notifier).refresh();
  };
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
