import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Position notifier with pagination support
/// Manages the state of positions and handles API calls
class PositionNotifier extends StateNotifier<PaginationState<Position>>
    with PaginationMixin<Position>
    implements PaginationController<Position> {
  final GetPositionsUseCase _getPositionsUseCase;
  final CreatePositionUseCase _createPositionUseCase;
  final DeletePositionUseCase _deletePositionUseCase;

  PositionNotifier(
    this._getPositionsUseCase,
    this._createPositionUseCase,
    this._deletePositionUseCase,
  ) : super(const PaginationState());

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

  /// Create a position
  Future<Position> createPosition(Map<String, dynamic> positionData) async {
    try {
      final newPosition = await _createPositionUseCase(positionData);

      // Update state optimistically after success (without full refresh)
      state = state.copyWith(
        items: [newPosition, ...state.items],
        totalItems: state.totalItems + 1,
      );

      return newPosition;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a position
  Future<void> deletePosition(int id, {bool hard = true}) async {
    // Keep a copy for rollback if needed?
    // The user asked for optimistic update.
    // Usually optimistic update in list means removing it immediately.

    final previousItems = state.items;
    final previousTotal = state.totalItems;

    // Optimistically remove
    state = state.copyWith(
      items: state.items.where((p) => p.id != id).toList(),
      totalItems: state.totalItems - 1,
    );

    try {
      await _deletePositionUseCase.execute(id, hard: hard);
    } catch (e) {
      // Rollback on error
      state = state.copyWith(items: previousItems, totalItems: previousTotal);
      rethrow;
    }
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
