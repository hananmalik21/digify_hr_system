import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Position notifier with pagination support
/// Manages the state of positions and handles API calls
class PositionNotifier extends StateNotifier<PaginationState<Position>>
    with PaginationMixin<Position>
    implements PaginationController<Position> {
  final GetPositionsUseCase _getPositionsUseCase;

  PositionNotifier(this._getPositionsUseCase) : super(const PaginationState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getPositionsUseCase(
        page: 1,
        pageSize: state.pageSize,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.positions,
        currentPage: response.page,
        pageSize: response.pageSize,
        totalItems: response.totalCount,
        totalPages: response.totalPages,
        hasNextPage: response.hasNext,
        hasPreviousPage: response.hasPrevious,
        isFirstPage: true,
      );
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    state = handleLoadingState(state, false);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _getPositionsUseCase(
        page: nextPage,
        pageSize: state.pageSize,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.positions,
        currentPage: response.page,
        pageSize: response.pageSize,
        totalItems: response.totalCount,
        totalPages: response.totalPages,
        hasNextPage: response.hasNext,
        hasPreviousPage: response.hasPrevious,
        isFirstPage: false,
      );
    } catch (e) {
      state = handleErrorState(state, e.toString());
    }
  }

  @override
  Future<void> refresh() async {
    reset();
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const PaginationState();
  }

  /// Update page size and refresh
  void updatePageSize(int newPageSize) {
    if (newPageSize != state.pageSize) {
      state = state.copyWith(pageSize: newPageSize);
      refresh();
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
