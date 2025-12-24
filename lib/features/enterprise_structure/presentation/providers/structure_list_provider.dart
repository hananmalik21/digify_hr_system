import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_structure_list_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for structure list with pagination
class StructureListState {
  final List<StructureListItem> structures;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final bool hasError;
  final PaginationInfo? pagination;
  final int total;
  final int currentPage;
  final int pageSize;

  const StructureListState({
    this.structures = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.hasError = false,
    this.pagination,
    this.total = 0,
    this.currentPage = 1,
    this.pageSize = 10,
  });

  StructureListState copyWith({
    List<StructureListItem>? structures,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool? hasError,
    PaginationInfo? pagination,
    int? total,
    int? currentPage,
    int? pageSize,
  }) {
    return StructureListState(
      structures: structures ?? this.structures,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      pagination: pagination ?? this.pagination,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  bool get hasMore => pagination?.hasNext ?? false;
  bool get hasPrevious => pagination?.hasPrevious ?? false;
}

/// Notifier for structure list with pagination
class StructureListNotifier extends StateNotifier<StructureListState> {
  final GetStructureListUseCase getStructureListUseCase;

  StructureListNotifier({required this.getStructureListUseCase})
      : super(const StructureListState()) {
    loadStructures();
  }

  /// Load structures for the first page
  Future<void> loadStructures({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        currentPage: 1,
      );
    } else if (state.isLoading) {
      return; // Already loading
    } else {
      state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);
    }

    try {
      final result = await getStructureListUseCase(
        page: refresh ? 1 : state.currentPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        structures: result.structures,
        pagination: result.pagination,
        total: result.total,
        isLoading: false,
        hasError: false,
        currentPage: result.pagination.page,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load structures: ${e.toString()}',
      );
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await getStructureListUseCase(
        page: nextPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        structures: [...state.structures, ...result.structures],
        pagination: result.pagination,
        total: result.total,
        isLoadingMore: false,
        currentPage: nextPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: 'Failed to load more structures: ${e.toString()}',
      );
    }
  }

  /// Load previous page
  Future<void> loadPreviousPage() async {
    if (state.isLoading || !state.hasPrevious) return;

    state = state.copyWith(isLoading: true);

    try {
      final previousPage = state.currentPage - 1;
      final result = await getStructureListUseCase(
        page: previousPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        structures: result.structures,
        pagination: result.pagination,
        total: result.total,
        isLoading: false,
        currentPage: previousPage,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load structures: ${e.toString()}',
      );
    }
  }

  /// Refresh the list
  Future<void> refresh() async {
    await loadStructures(refresh: true);
  }
}



