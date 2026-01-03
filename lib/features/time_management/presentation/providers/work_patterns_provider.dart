import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/work_pattern_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/work_pattern_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/work_pattern_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/create_work_pattern_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/delete_work_pattern_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_work_patterns_usecase.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_pattern_create_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workPatternRemoteDataSourceProvider = Provider<WorkPatternRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkPatternRemoteDataSourceImpl(apiClient: apiClient);
});

final workPatternRepositoryProvider = Provider.family<WorkPatternRepository, int>((ref, enterpriseId) {
  final remoteDataSource = ref.watch(workPatternRemoteDataSourceProvider);
  return WorkPatternRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: enterpriseId);
});

final getWorkPatternsUseCaseProvider = Provider.family<GetWorkPatternsUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return GetWorkPatternsUseCase(repository: repository);
});

final createWorkPatternUseCaseProvider = Provider.family<CreateWorkPatternUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return CreateWorkPatternUseCase(repository: repository);
});

final deleteWorkPatternUseCaseProvider = Provider.family<DeleteWorkPatternUseCase, int>((ref, enterpriseId) {
  final repository = ref.watch(workPatternRepositoryProvider(enterpriseId));
  return DeleteWorkPatternUseCase(repository: repository);
});

class WorkPatternState extends PaginationState<WorkPattern> {
  const WorkPatternState({
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
  });

  @override
  WorkPatternState copyWith({
    List<WorkPattern>? items,
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
    bool clearItems = false,
  }) {
    return WorkPatternState(
      items: clearItems ? const [] : (items ?? this.items),
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
    );
  }
}

final workPatternsNotifierProvider = StateNotifierProvider.family<WorkPatternsNotifier, WorkPatternState, int>((
  ref,
  enterpriseId,
) {
  return WorkPatternsNotifier(
    ref.read(getWorkPatternsUseCaseProvider(enterpriseId)),
    ref.read(createWorkPatternUseCaseProvider(enterpriseId)),
    ref.read(deleteWorkPatternUseCaseProvider(enterpriseId)),
  );
});

class WorkPatternsNotifier extends StateNotifier<WorkPatternState>
    with PaginationMixin<WorkPattern>
    implements PaginationController<WorkPattern> {
  final GetWorkPatternsUseCase _getWorkPatternsUseCase;
  final CreateWorkPatternUseCase _createWorkPatternUseCase;
  final DeleteWorkPatternUseCase _deleteWorkPatternUseCase;
  int? _currentEnterpriseId;

  WorkPatternsNotifier(this._getWorkPatternsUseCase, this._createWorkPatternUseCase, this._deleteWorkPatternUseCase)
    : super(const WorkPatternState());

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
    state = WorkPatternState(
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
      final result = await _getWorkPatternsUseCase(page: 1, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workPatterns,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: true,
      );
      state = WorkPatternState(
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
      state = WorkPatternState(
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
    if (_currentEnterpriseId == null || state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    final loadingState = handleLoadingState(state, false);
    state = WorkPatternState(
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
      final result = await _getWorkPatternsUseCase(page: nextPage, pageSize: state.pageSize);

      final newState = handleSuccessState(
        currentState: state,
        newItems: result.workPatterns,
        currentPage: result.pagination.currentPage,
        pageSize: result.pagination.pageSize,
        totalItems: result.pagination.totalItems,
        totalPages: result.pagination.totalPages,
        hasNextPage: result.pagination.hasNext,
        hasPreviousPage: result.pagination.hasPrevious,
        isFirstPage: false,
      );
      state = WorkPatternState(
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
      state = WorkPatternState(
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
    state = const WorkPatternState();
  }

  /// Create a work pattern with optimistic update
  Future<WorkPattern> createWorkPattern(
    WidgetRef ref, {
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    ref.read(workPatternCreateStateProvider.notifier).state = const WorkPatternCreateState(isCreating: true);

    try {
      final createdPattern = await _createWorkPatternUseCase.execute(
        patternCode: patternCode,
        patternNameEn: patternNameEn,
        patternNameAr: patternNameAr,
        patternType: patternType,
        totalHoursPerWeek: totalHoursPerWeek,
        status: status,
        days: days,
      );

      ref.read(workPatternCreateStateProvider.notifier).state = const WorkPatternCreateState(isCreating: false);

      // Optimistically update the list - add to the beginning
      state = state.copyWith(items: [createdPattern, ...state.items], totalItems: state.totalItems + 1);

      return createdPattern;
    } catch (e) {
      ref.read(workPatternCreateStateProvider.notifier).state = WorkPatternCreateState(
        isCreating: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Delete a work pattern - wait for API response before updating list
  Future<void> deleteWorkPattern({required int workPatternId, required bool hard}) async {
    try {
      await _deleteWorkPatternUseCase.execute(workPatternId: workPatternId, hard: hard);

      state = state.copyWith(
        items: state.items.where((p) => p.workPatternId != workPatternId).toList(),
        totalItems: state.totalItems - 1,
      );
    } catch (e) {
      rethrow;
    }
  }
}
