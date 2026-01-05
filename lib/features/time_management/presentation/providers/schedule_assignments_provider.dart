import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/schedule_assignment_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/schedule_assignment_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/schedule_assignment.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/schedule_assignment_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_schedule_assignments_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleAssignmentApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final scheduleAssignmentRemoteDataSourceProvider = Provider<ScheduleAssignmentRemoteDataSource>((ref) {
  final apiClient = ref.watch(scheduleAssignmentApiClientProvider);
  return ScheduleAssignmentRemoteDataSourceImpl(apiClient: apiClient);
});

final scheduleAssignmentRepositoryProvider = Provider.family<ScheduleAssignmentRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(scheduleAssignmentRemoteDataSourceProvider);
  return ScheduleAssignmentRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

final getScheduleAssignmentsUseCaseProvider = Provider.family<GetScheduleAssignmentsUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(scheduleAssignmentRepositoryProvider(enterpriseId));
  return GetScheduleAssignmentsUseCase(repository: repository);
});

class ScheduleAssignmentState extends PaginationState<ScheduleAssignment> {
  const ScheduleAssignmentState({
    super.items = const [],
    super.isLoading = false,
    super.isLoadingMore = false,
    super.hasError = false,
    super.errorMessage,
    super.currentPage = 1,
    super.pageSize = 10,
    super.totalItems = 0,
    super.totalPages = 0,
    super.hasNextPage = false,
    super.hasPreviousPage = false,
    super.searchQuery,
    super.status,
  });

  @override
  ScheduleAssignmentState copyWith({
    List<ScheduleAssignment>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    String? searchQuery,
    PositionStatus? status,
    bool clearStatus = false,
  }) {
    return ScheduleAssignmentState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}

final scheduleAssignmentsNotifierProvider =
    StateNotifierProvider.family<ScheduleAssignmentsNotifier, ScheduleAssignmentState, int>((ref, enterpriseId) {
      return ScheduleAssignmentsNotifier(ref.read(getScheduleAssignmentsUseCaseProvider(enterpriseId)));
    });

class ScheduleAssignmentsNotifier extends StateNotifier<ScheduleAssignmentState>
    with PaginationMixin<ScheduleAssignment>
    implements PaginationController<ScheduleAssignment> {
  final GetScheduleAssignmentsUseCase _getScheduleAssignmentsUseCase;
  int? _currentEnterpriseId;

  ScheduleAssignmentsNotifier(this._getScheduleAssignmentsUseCase) : super(const ScheduleAssignmentState());

  void setEnterpriseId(int enterpriseId) {
    if (_currentEnterpriseId != enterpriseId) {
      _currentEnterpriseId = enterpriseId;
      reset();
      loadFirstPage();
    }
  }

  @override
  Future<void> loadFirstPage() async {
    if (_currentEnterpriseId == null) return;

    final loadingState = handleLoadingState(state, true);
    state = ScheduleAssignmentState(
      items: loadingState.items,
      isLoading: loadingState.isLoading,
      isLoadingMore: loadingState.isLoadingMore,
      hasError: loadingState.hasError,
      errorMessage: loadingState.errorMessage,
      currentPage: loadingState.currentPage,
      pageSize: loadingState.pageSize,
      totalItems: loadingState.totalItems,
      totalPages: loadingState.totalPages,
      hasNextPage: loadingState.hasNextPage,
      hasPreviousPage: loadingState.hasPreviousPage,
    );

    try {
      final result = await _getScheduleAssignmentsUseCase.call(
        tenantId: _currentEnterpriseId!,
        page: 1,
        pageSize: state.pageSize,
      );

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.scheduleAssignments,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: true,
      );
      state = ScheduleAssignmentState(
        items: newState.items,
        isLoading: newState.isLoading,
        isLoadingMore: newState.isLoadingMore,
        hasError: newState.hasError,
        errorMessage: newState.errorMessage,
        currentPage: newState.currentPage,
        pageSize: newState.pageSize,
        totalItems: newState.totalItems,
        totalPages: newState.totalPages,
        hasNextPage: newState.hasNextPage,
        hasPreviousPage: newState.hasPreviousPage,
      );
    } catch (e) {
      final errorState = handleErrorState(state, e.toString());
      state = ScheduleAssignmentState(
        items: errorState.items,
        isLoading: errorState.isLoading,
        isLoadingMore: errorState.isLoadingMore,
        hasError: errorState.hasError,
        errorMessage: errorState.errorMessage,
        currentPage: errorState.currentPage,
        pageSize: errorState.pageSize,
        totalItems: errorState.totalItems,
        totalPages: errorState.totalPages,
        hasNextPage: errorState.hasNextPage,
        hasPreviousPage: errorState.hasPreviousPage,
      );
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (_currentEnterpriseId == null) return;
    if (state.isLoadingMore || !state.hasNextPage) return;

    final loadingState = handleLoadingState(state, false);
    state = ScheduleAssignmentState(
      items: loadingState.items,
      isLoading: loadingState.isLoading,
      isLoadingMore: loadingState.isLoadingMore,
      hasError: loadingState.hasError,
      errorMessage: loadingState.errorMessage,
      currentPage: loadingState.currentPage,
      pageSize: loadingState.pageSize,
      totalItems: loadingState.totalItems,
      totalPages: loadingState.totalPages,
      hasNextPage: loadingState.hasNextPage,
      hasPreviousPage: loadingState.hasPreviousPage,
    );

    try {
      final nextPage = state.currentPage + 1;
      final result = await _getScheduleAssignmentsUseCase.call(
        tenantId: _currentEnterpriseId!,
        page: nextPage,
        pageSize: state.pageSize,
      );

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.scheduleAssignments,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: false,
      );
      state = ScheduleAssignmentState(
        items: newState.items,
        isLoading: newState.isLoading,
        isLoadingMore: newState.isLoadingMore,
        hasError: newState.hasError,
        errorMessage: newState.errorMessage,
        currentPage: newState.currentPage,
        pageSize: newState.pageSize,
        totalItems: newState.totalItems,
        totalPages: newState.totalPages,
        hasNextPage: newState.hasNextPage,
        hasPreviousPage: newState.hasPreviousPage,
      );
    } catch (e) {
      final errorState = handleErrorState(state, e.toString());
      state = ScheduleAssignmentState(
        items: errorState.items,
        isLoading: errorState.isLoading,
        isLoadingMore: errorState.isLoadingMore,
        hasError: errorState.hasError,
        errorMessage: errorState.errorMessage,
        currentPage: errorState.currentPage,
        pageSize: errorState.pageSize,
        totalItems: errorState.totalItems,
        totalPages: errorState.totalPages,
        hasNextPage: errorState.hasNextPage,
        hasPreviousPage: errorState.hasPreviousPage,
      );
    }
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const ScheduleAssignmentState();
  }
}
