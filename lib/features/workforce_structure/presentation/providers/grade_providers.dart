import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/grade_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/grade_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/grade_repository.dart';
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

// Grade Notifier with pagination
class GradeNotifier extends StateNotifier<PaginationState<Grade>>
    with PaginationMixin<Grade>
    implements PaginationController<Grade> {
  final GetGradesUseCase _getGradesUseCase;

  GradeNotifier(this._getGradesUseCase) : super(const PaginationState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getGradesUseCase.execute(
        page: 1,
        pageSize: state.pageSize,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.data,
        currentPage: response.meta.pagination.page,
        pageSize: response.meta.pagination.pageSize,
        totalItems: response.meta.pagination.total,
        totalPages: response.meta.pagination.totalPages,
        hasNextPage: response.meta.pagination.hasNext,
        hasPreviousPage: response.meta.pagination.hasPrevious,
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
      final response = await _getGradesUseCase.execute(
        page: nextPage,
        pageSize: state.pageSize,
      );

      state = handleSuccessState(
        currentState: state,
        newItems: response.data,
        currentPage: response.meta.pagination.page,
        pageSize: response.meta.pagination.pageSize,
        totalItems: response.meta.pagination.total,
        totalPages: response.meta.pagination.totalPages,
        hasNextPage: response.meta.pagination.hasNext,
        hasPreviousPage: response.meta.pagination.hasPrevious,
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
}

// Provider for the notifier
final gradeNotifierProvider =
    StateNotifierProvider<GradeNotifier, PaginationState<Grade>>((ref) {
      return GradeNotifier(ref.read(getGradesUseCaseProvider));
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
