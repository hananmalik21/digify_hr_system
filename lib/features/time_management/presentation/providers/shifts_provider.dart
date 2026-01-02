import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/shift_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/shift_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/shift_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_shifts_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _defaultTenantId = 1001;

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final shiftRemoteDataSourceProvider = Provider<ShiftRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ShiftRemoteDataSourceImpl(apiClient: apiClient);
});

final shiftRepositoryProvider = Provider<ShiftRepository>((ref) {
  final remoteDataSource = ref.watch(shiftRemoteDataSourceProvider);
  return ShiftRepositoryImpl(
    remoteDataSource: remoteDataSource,
    tenantId: _defaultTenantId,
  );
});

final getShiftsUseCaseProvider = Provider<GetShiftsUseCase>((ref) {
  return GetShiftsUseCase(repository: ref.read(shiftRepositoryProvider));
});

/// Shifts Notifier with pagination support
class ShiftsNotifier extends StateNotifier<PaginationState<ShiftOverview>>
    with PaginationMixin<ShiftOverview>
    implements PaginationController<ShiftOverview> {
  final GetShiftsUseCase _getShiftsUseCase;
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 500),
  );

  ShiftsNotifier(this._getShiftsUseCase) : super(const PaginationState());

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getShiftsUseCase(
        search: state.searchQuery,
        isActive: _getActiveStatusFilter(),
        page: 1,
        pageSize: state.pageSize.clamp(1, 100),
      );

      final shifts = response.shifts.isEmpty
          ? <ShiftOverview>[]
          : response.shifts;
      final pagination = response.pagination;

      final validCurrentPage = pagination.currentPage < 1
          ? 1
          : pagination.currentPage;
      final validPageSize = pagination.pageSize < 1
          ? state.pageSize
          : pagination.pageSize;
      final validTotalItems = pagination.totalItems < 0
          ? 0
          : pagination.totalItems;
      final validTotalPages = pagination.totalPages < 0
          ? 0
          : pagination.totalPages;

      state = handleSuccessState(
        currentState: state,
        newItems: shifts,
        currentPage: validCurrentPage,
        pageSize: validPageSize,
        totalItems: validTotalItems,
        totalPages: validTotalPages,
        hasNextPage: pagination.hasNext && validCurrentPage < validTotalPages,
        hasPreviousPage: pagination.hasPrevious && validCurrentPage > 1,
        isFirstPage: true,
      );
    } catch (e) {
      final errorMessage = e.toString();
      state = handleErrorState(
        state,
        errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage,
      );
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage || state.currentPage < 1)
      return;

    state = handleLoadingState(state, false);

    try {
      final nextPage = state.currentPage + 1;

      if (state.totalPages > 0 && nextPage > state.totalPages) {
        state = state.copyWith(
          isLoadingMore: false,
          hasError: true,
          errorMessage: 'Cannot load page beyond total pages',
        );
        return;
      }

      final response = await _getShiftsUseCase(
        search: state.searchQuery,
        isActive: _getActiveStatusFilter(),
        page: nextPage,
        pageSize: state.pageSize.clamp(1, 100),
      );

      final shifts = response.shifts.isEmpty
          ? <ShiftOverview>[]
          : response.shifts;
      final pagination = response.pagination;

      final validCurrentPage = pagination.currentPage < 1
          ? nextPage
          : pagination.currentPage;
      final validPageSize = pagination.pageSize < 1
          ? state.pageSize
          : pagination.pageSize;
      final validTotalItems = pagination.totalItems < 0
          ? state.totalItems
          : pagination.totalItems;
      final validTotalPages = pagination.totalPages < 0
          ? state.totalPages
          : pagination.totalPages;

      state = handleSuccessState(
        currentState: state,
        newItems: shifts,
        currentPage: validCurrentPage,
        pageSize: validPageSize,
        totalItems: validTotalItems,
        totalPages: validTotalPages,
        hasNextPage: pagination.hasNext && validCurrentPage < validTotalPages,
        hasPreviousPage: pagination.hasPrevious && validCurrentPage > 1,
        isFirstPage: false,
      );
    } catch (e) {
      final errorMessage = e.toString();
      state = handleErrorState(
        state,
        errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage,
      );
    }
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = PaginationState(pageSize: state.pageSize);
  }

  void search(String query) {
    final normalizedQuery = query.trim();

    if (state.searchQuery == normalizedQuery) return;

    state = state.copyWith(searchQuery: normalizedQuery);
    _debouncer.run(() {
      refresh();
    });
  }

  void setStatusFilter(bool? isActive) {
    final status = isActive == null
        ? null
        : (isActive ? PositionStatus.active : PositionStatus.inactive);

    if (state.status == status) return;

    if (status == null) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(status: status);
    }
    refresh();
  }

  bool? _getActiveStatusFilter() {
    if (state.status == null) return null;
    return state.status == PositionStatus.active;
  }
}

final shiftsNotifierProvider =
    StateNotifierProvider<ShiftsNotifier, PaginationState<ShiftOverview>>((
      ref,
    ) {
      return ShiftsNotifier(ref.read(getShiftsUseCaseProvider));
    });
