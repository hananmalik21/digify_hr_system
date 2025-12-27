import 'dart:async';

import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/division.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_divisions_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for divisions list
class DivisionsState {
  final List<DivisionOverview> divisions;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;
  final String searchQuery;
  final int currentPage;
  final int pageSize;

  const DivisionsState({
    this.divisions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
    this.searchQuery = '',
    this.currentPage = 1,
    this.pageSize = 10,
  });

  DivisionsState copyWith({
    List<DivisionOverview>? divisions,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
    String? searchQuery,
    int? currentPage,
    int? pageSize,
  }) {
    return DivisionsState(
      divisions: divisions ?? this.divisions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// Notifier for divisions list
/// This provider automatically loads divisions when accessed
class DivisionsNotifier extends StateNotifier<DivisionsState> {
  final GetDivisionsUseCase getDivisionsUseCase;
  Timer? _debounceTimer;

  DivisionsNotifier({required this.getDivisionsUseCase})
      : super(const DivisionsState()) {
    _loadDivisions();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadDivisions({String? search, int? page, int? pageSize}) async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final divisions = await getDivisionsUseCase(
        search: search ?? (state.searchQuery.isNotEmpty ? state.searchQuery : null),
        page: page ?? state.currentPage,
        pageSize: pageSize ?? state.pageSize,
      );
      state = state.copyWith(
        divisions: divisions,
        isLoading: false,
        hasError: false,
        searchQuery: search != null ? search : state.searchQuery,
        currentPage: page ?? state.currentPage,
        pageSize: pageSize ?? state.pageSize,
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
        errorMessage: 'Failed to load divisions: ${e.toString()}',
      );
    }
  }

  /// Search divisions with debouncing
  void searchDivisions(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _loadDivisions(
        search: query.trim(),
        page: 1, // Reset to first page on search
      );
    });
  }

  Future<void> refresh() async {
    await _loadDivisions();
  }
}

/// Provider for divisions list
/// This provider automatically loads divisions every time it's accessed
final divisionsProvider =
    StateNotifierProvider.autoDispose<DivisionsNotifier, DivisionsState>(
        (ref) {
  final getDivisionsUseCase = ref.watch(getDivisionsUseCaseProvider);
  return DivisionsNotifier(getDivisionsUseCase: getDivisionsUseCase);
});
