import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/update_position_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionNotifier extends StateNotifier<PaginationState<Position>>
    with PaginationMixin<Position>
    implements PaginationController<Position> {
  final GetPositionsUseCase _getPositionsUseCase;
  final CreatePositionUseCase _createPositionUseCase;
  final UpdatePositionUseCase _updatePositionUseCase;
  final DeletePositionUseCase _deletePositionUseCase;

  PositionNotifier(
    this._getPositionsUseCase,
    this._createPositionUseCase,
    this._updatePositionUseCase,
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
        search: state.searchQuery,
        status: state.status,
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
        search: state.searchQuery,
        status: state.status,
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

  Future<void> goToPage(int page) async {
    if (page < 1 || state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getPositionsUseCase(
        page: page,
        pageSize: state.pageSize,
        search: state.searchQuery,
        status: state.status,
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
  Future<void> refresh() async {
    await loadFirstPage();
  }

  @override
  void reset() {
    state = PaginationState(pageSize: state.pageSize);
  }

  void search(String query) {
    if (state.searchQuery == query) return;

    state = state.copyWith(searchQuery: query);
    refresh();
  }

  void clearSearch() {
    if (state.searchQuery == null || state.searchQuery!.isEmpty) return;

    state = state.copyWith(searchQuery: '');
    refresh();
  }

  void setStatus(PositionStatus? status) {
    if (state.status == status) return;

    if (status == null) {
      state = state.copyWith(clearStatus: true);
    } else {
      state = state.copyWith(status: status);
    }
    refresh();
  }

  Future<Position> createPosition(Map<String, dynamic> positionData) async {
    try {
      final newPosition = await _createPositionUseCase(positionData);

      state = state.copyWith(items: [newPosition, ...state.items], totalItems: state.totalItems + 1);

      return newPosition;
    } catch (e) {
      rethrow;
    }
  }

  Future<Position> updatePosition(String id, Map<String, dynamic> positionData) async {
    try {
      final updatedPosition = await _updatePositionUseCase.execute(id, positionData);

      state = state.copyWith(items: state.items.map((p) => p.id == id ? updatedPosition : p).toList());

      return updatedPosition;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePosition(String id, {bool hard = true}) async {
    final previousItems = state.items;
    final previousTotal = state.totalItems;

    state = state.copyWith(items: state.items.where((p) => p.id != id).toList(), totalItems: state.totalItems - 1);

    try {
      await _deletePositionUseCase.execute(id, hard: hard);
    } catch (e) {
      state = state.copyWith(items: previousItems, totalItems: previousTotal);
      rethrow;
    }
  }

  void updatePageSize(int newPageSize) {
    if (newPageSize != state.pageSize) {
      state = state.copyWith(pageSize: newPageSize);
      refresh();
    }
  }

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
