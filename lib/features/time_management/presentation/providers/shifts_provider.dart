import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/shift_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/shift_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/shift_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/delete_shift_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_shifts_usecase.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/update_shift_usecase.dart';
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
  return ShiftRepositoryImpl(remoteDataSource: remoteDataSource, tenantId: _defaultTenantId);
});

final getShiftsUseCaseProvider = Provider<GetShiftsUseCase>((ref) {
  return GetShiftsUseCase(repository: ref.read(shiftRepositoryProvider));
});

final deleteShiftUseCaseProvider = Provider<DeleteShiftUseCase>((ref) {
  return DeleteShiftUseCase(repository: ref.read(shiftRepositoryProvider));
});

final updateShiftUseCaseProvider = Provider<UpdateShiftUseCase>((ref) {
  return UpdateShiftUseCase(repository: ref.read(shiftRepositoryProvider));
});

/// Shift State that extends PaginationState with deletion status
class ShiftState extends PaginationState<ShiftOverview> {
  final bool isDeleting;
  final int? deletingShiftId;

  const ShiftState({
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
    this.isDeleting = false,
    this.deletingShiftId,
  });

  @override
  ShiftState copyWith({
    List<ShiftOverview>? items,
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
    bool? isDeleting,
    int? deletingShiftId,
    bool clearDeletingShiftId = false,
  }) {
    return ShiftState(
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
      isDeleting: isDeleting ?? this.isDeleting,
      deletingShiftId: clearDeletingShiftId ? null : (deletingShiftId ?? this.deletingShiftId),
    );
  }
}

/// Shifts Notifier with pagination support
class ShiftsNotifier extends StateNotifier<ShiftState>
    with PaginationMixin<ShiftOverview>
    implements PaginationController<ShiftOverview> {
  final GetShiftsUseCase _getShiftsUseCase;
  final UpdateShiftUseCase _updateShiftUseCase;
  final DeleteShiftUseCase _deleteShiftUseCase;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  ShiftsNotifier(this._getShiftsUseCase, this._updateShiftUseCase, this._deleteShiftUseCase)
    : super(const ShiftState());

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true) as ShiftState;

    try {
      final response = await _getShiftsUseCase(
        search: state.searchQuery,
        isActive: _getActiveStatusFilter(),
        page: 1,
        pageSize: state.pageSize.clamp(1, 100),
      );

      final shifts = response.shifts.isEmpty ? <ShiftOverview>[] : response.shifts;
      final pagination = response.pagination;

      final validCurrentPage = pagination.currentPage < 1 ? 1 : pagination.currentPage;
      final validPageSize = pagination.pageSize < 1 ? state.pageSize : pagination.pageSize;
      final validTotalItems = pagination.totalItems < 0 ? 0 : pagination.totalItems;
      final validTotalPages = pagination.totalPages < 0 ? 0 : pagination.totalPages;

      state =
          handleSuccessState(
                currentState: state,
                newItems: shifts,
                currentPage: validCurrentPage,
                pageSize: validPageSize,
                totalItems: validTotalItems,
                totalPages: validTotalPages,
                hasNextPage: pagination.hasNext && validCurrentPage < validTotalPages,
                hasPreviousPage: pagination.hasPrevious && validCurrentPage > 1,
                isFirstPage: true,
              )
              as ShiftState;
    } catch (e) {
      final errorMessage = e.toString();
      state =
          handleErrorState(state, errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage) as ShiftState;
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage || state.currentPage < 1) {
      return;
    }

    state = handleLoadingState(state, false) as ShiftState;

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

      final shifts = response.shifts.isEmpty ? <ShiftOverview>[] : response.shifts;
      final pagination = response.pagination;

      final validCurrentPage = pagination.currentPage < 1 ? nextPage : pagination.currentPage;
      final validPageSize = pagination.pageSize < 1 ? state.pageSize : pagination.pageSize;
      final validTotalItems = pagination.totalItems < 0 ? state.totalItems : pagination.totalItems;
      final validTotalPages = pagination.totalPages < 0 ? state.totalPages : pagination.totalPages;

      state =
          handleSuccessState(
                currentState: state,
                newItems: shifts,
                currentPage: validCurrentPage,
                pageSize: validPageSize,
                totalItems: validTotalItems,
                totalPages: validTotalPages,
                hasNextPage: pagination.hasNext && validCurrentPage < validTotalPages,
                hasPreviousPage: pagination.hasPrevious && validCurrentPage > 1,
                isFirstPage: false,
              )
              as ShiftState;
    } catch (e) {
      final errorMessage = e.toString();
      state =
          handleErrorState(state, errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage) as ShiftState;
    }
  }

  @override
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = ShiftState(pageSize: state.pageSize);
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
    final status = isActive == null ? null : (isActive ? PositionStatus.active : PositionStatus.inactive);

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

  void addShiftOptimistically(ShiftOverview shift) {
    final currentItems = List<ShiftOverview>.from(state.items);
    currentItems.insert(0, shift);

    state = state.copyWith(items: currentItems, totalItems: state.totalItems + 1);
  }

  Future<ShiftOverview?> updateShift({required int shiftId, required Map<String, dynamic> shiftData}) async {
    try {
      final updatedShift = await _updateShiftUseCase.call(shiftId: shiftId, shiftData: shiftData);

      final updatedItems = state.items.map((shift) => shift.id == shiftId ? updatedShift : shift).toList();

      state = state.copyWith(items: updatedItems);

      return updatedShift;
    } on AppException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteShift({required int shiftId, required bool hard}) async {
    if (state.isDeleting) return false;

    state = state.copyWith(isDeleting: true, deletingShiftId: shiftId);

    try {
      await _deleteShiftUseCase.call(shiftId: shiftId, hard: hard);

      final updatedItems = state.items.where((shift) => shift.id != shiftId).toList();
      final newTotalItems = (state.totalItems - 1).clamp(0, double.infinity).toInt();

      state = state.copyWith(
        items: updatedItems,
        totalItems: newTotalItems,
        isDeleting: false,
        clearDeletingShiftId: true,
      );

      return true;
    } on AppException {
      state = state.copyWith(isDeleting: false, clearDeletingShiftId: true);
      rethrow;
    } catch (e) {
      state = state.copyWith(isDeleting: false, clearDeletingShiftId: true);
      rethrow;
    }
  }
}

final shiftsNotifierProvider = StateNotifierProvider<ShiftsNotifier, ShiftState>((ref) {
  return ShiftsNotifier(
    ref.read(getShiftsUseCaseProvider),
    ref.read(updateShiftUseCaseProvider),
    ref.read(deleteShiftUseCaseProvider),
  );
});
