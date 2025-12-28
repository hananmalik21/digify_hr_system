import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/grade_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/grade_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/create_grade_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_grades_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final gradeRemoteDataSourceProvider = Provider<GradeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GradeRemoteDataSourceImpl(apiClient: apiClient);
});

final gradeRepositoryProvider = Provider<GradeRepository>((ref) {
  return GradeRepositoryImpl(
    remoteDataSource: ref.read(gradeRemoteDataSourceProvider),
  );
});

final getGradesUseCaseProvider = Provider<GetGradesUseCase>((ref) {
  return GetGradesUseCase(ref.read(gradeRepositoryProvider));
});

final createGradeUseCaseProvider = Provider<CreateGradeUseCase>((ref) {
  return CreateGradeUseCase(ref.read(gradeRepositoryProvider));
});

// Grade State that extends PaginationState with creating status
class GradeState extends PaginationState<Grade> {
  final bool isCreating;

  const GradeState({
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
    this.isCreating = false,
  });

  @override
  GradeState copyWith({
    List<Grade>? items,
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
    bool? isCreating,
  }) {
    return GradeState(
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
      isCreating: isCreating ?? this.isCreating,
    );
  }
}

// Grade Notifier with pagination
class GradeNotifier extends StateNotifier<GradeState>
    with PaginationMixin<Grade>
    implements PaginationController<Grade> {
  final GetGradesUseCase _getGradesUseCase;
  final CreateGradeUseCase _createGradeUseCase;

  GradeNotifier(this._getGradesUseCase, this._createGradeUseCase)
    : super(const GradeState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true) as GradeState;

    try {
      final response = await _getGradesUseCase.execute(
        page: 1,
        pageSize: state.pageSize,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: response.data,
                currentPage: response.meta.pagination.page,
                pageSize: response.meta.pagination.pageSize,
                totalItems: response.meta.pagination.total,
                totalPages: response.meta.pagination.totalPages,
                hasNextPage: response.meta.pagination.hasNext,
                hasPreviousPage: response.meta.pagination.hasPrevious,
                isFirstPage: true,
              )
              as GradeState;
    } catch (e) {
      state = handleErrorState(state, e.toString()) as GradeState;
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    state = handleLoadingState(state, false) as GradeState;

    try {
      final nextPage = state.currentPage + 1;
      final response = await _getGradesUseCase.execute(
        page: nextPage,
        pageSize: state.pageSize,
      );

      state =
          handleSuccessState(
                currentState: state,
                newItems: response.data,
                currentPage: response.meta.pagination.page,
                pageSize: response.meta.pagination.pageSize,
                totalItems: response.meta.pagination.total,
                totalPages: response.meta.pagination.totalPages,
                hasNextPage: response.meta.pagination.hasNext,
                hasPreviousPage: response.meta.pagination.hasPrevious,
                isFirstPage: false,
              )
              as GradeState;
    } catch (e) {
      state = handleErrorState(state, e.toString()) as GradeState;
    }
  }

  @override
  Future<void> refresh() async {
    reset();
    await loadFirstPage();
  }

  @override
  void reset() {
    state = const GradeState();
  }

  Future<void> createGrade(Grade grade) async {
    state = state.copyWith(isCreating: true);
    try {
      final createdGrade = await _createGradeUseCase.execute(grade);
      // Add the new grade to the beginning of the list
      state = state.copyWith(
        items: [createdGrade, ...state.items],
        totalItems: state.totalItems + 1,
        isCreating: false,
      );
    } catch (e) {
      state = state.copyWith(isCreating: false);
      rethrow;
    }
  }
}

// Provider for the notifier
final gradeNotifierProvider = StateNotifierProvider<GradeNotifier, GradeState>((
  ref,
) {
  return GradeNotifier(
    ref.read(getGradesUseCaseProvider),
    ref.read(createGradeUseCaseProvider),
  );
});

// Convenience providers
final gradeListProvider = Provider<List<Grade>>((ref) {
  return ref.watch(gradeNotifierProvider).items;
});

final gradeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(gradeNotifierProvider).isLoading;
});

final gradeErrorProvider = Provider<String?>((ref) {
  return ref.watch(gradeNotifierProvider).errorMessage;
});

final gradeCreatingProvider = Provider<bool>((ref) {
  return ref.watch(gradeNotifierProvider).isCreating;
});
