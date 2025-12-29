import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/job_level_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/job_level_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_level_repository.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/create_job_level_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/delete_job_level_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_job_levels_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/update_job_level_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_create_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final jobLevelRemoteDataSourceProvider = Provider<JobLevelRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return JobLevelRemoteDataSourceImpl(apiClient: apiClient);
});

final jobLevelRepositoryProvider = Provider<JobLevelRepository>((ref) {
  return JobLevelRepositoryImpl(
    remoteDataSource: ref.read(jobLevelRemoteDataSourceProvider),
  );
});

final getJobLevelsUseCaseProvider = Provider<GetJobLevelsUseCase>((ref) {
  return GetJobLevelsUseCase(ref.read(jobLevelRepositoryProvider));
});

final createJobLevelUseCaseProvider = Provider<CreateJobLevelUseCase>((ref) {
  return CreateJobLevelUseCase(ref.read(jobLevelRepositoryProvider));
});

final updateJobLevelUseCaseProvider = Provider<UpdateJobLevelUseCase>((ref) {
  return UpdateJobLevelUseCase(ref.read(jobLevelRepositoryProvider));
});

final deleteJobLevelUseCaseProvider = Provider<DeleteJobLevelUseCase>((ref) {
  return DeleteJobLevelUseCase(ref.read(jobLevelRepositoryProvider));
});

// Create operation state provider
final jobLevelCreateStateProvider = StateProvider<JobLevelCreateState>(
  (ref) => const JobLevelCreateState(),
);

// Job Level Notifier with pagination
class JobLevelNotifier extends StateNotifier<PaginationState<JobLevel>>
    with PaginationMixin<JobLevel>
    implements PaginationController<JobLevel> {
  final GetJobLevelsUseCase _getJobLevelsUseCase;
  final CreateJobLevelUseCase _createJobLevelUseCase;
  final UpdateJobLevelUseCase _updateJobLevelUseCase;
  final DeleteJobLevelUseCase _deleteJobLevelUseCase;
  final _debouncer = Debouncer();

  JobLevelNotifier(
    this._getJobLevelsUseCase,
    this._createJobLevelUseCase,
    this._updateJobLevelUseCase,
    this._deleteJobLevelUseCase,
  ) : super(const PaginationState());

  /// Create a job level and update the state
  Future<JobLevel> createJobLevel(WidgetRef ref, JobLevel jobLevel) async {
    ref.read(jobLevelCreateStateProvider.notifier).state =
        const JobLevelCreateState(isCreating: true);

    try {
      final createdLevel = await _createJobLevelUseCase.execute(jobLevel);

      ref.read(jobLevelCreateStateProvider.notifier).state =
          const JobLevelCreateState(isCreating: false);

      // Optimistically update the list
      state = state.copyWith(
        items: [createdLevel, ...state.items],
        totalItems: state.totalItems + 1,
      );

      return createdLevel;
    } catch (e) {
      ref.read(jobLevelCreateStateProvider.notifier).state =
          JobLevelCreateState(isCreating: false, error: e.toString());
      rethrow;
    }
  }

  /// Update a job level and update the state
  Future<JobLevel> updateJobLevel(WidgetRef ref, JobLevel jobLevel) async {
    ref.read(jobLevelCreateStateProvider.notifier).state =
        const JobLevelCreateState(isCreating: true);

    try {
      final updatedLevel = await _updateJobLevelUseCase.execute(jobLevel);

      ref.read(jobLevelCreateStateProvider.notifier).state =
          const JobLevelCreateState(isCreating: false);

      // Update the list
      state = state.copyWith(
        items: state.items.map((item) {
          return item.id == updatedLevel.id ? updatedLevel : item;
        }).toList(),
      );

      return updatedLevel;
    } catch (e) {
      ref.read(jobLevelCreateStateProvider.notifier).state =
          JobLevelCreateState(isCreating: false, error: e.toString());
      rethrow;
    }
  }

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getJobLevelsUseCase.execute(
        page: 1,
        pageSize: state.pageSize,
        search: state.searchQuery,
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
      final response = await _getJobLevelsUseCase.execute(
        page: nextPage,
        pageSize: state.pageSize,
        search: state.searchQuery,
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

  /// Delete a job level and update the state
  Future<void> deleteJobLevel(int id) async {
    final previousItems = state.items;
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
      totalItems: state.totalItems - 1,
    );

    try {
      await _deleteJobLevelUseCase.execute(id);
    } catch (e) {
      // Rollback on error
      state = state.copyWith(
        items: previousItems,
        totalItems: previousItems.length,
      );
      rethrow;
    }
  }

  void search(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(searchQuery: query, items: []);
    _debouncer.run(() => loadFirstPage());
  }

  void clearSearch() {
    search('');
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

// Provider for the notifier
final jobLevelNotifierProvider =
    StateNotifierProvider<JobLevelNotifier, PaginationState<JobLevel>>((ref) {
      return JobLevelNotifier(
        ref.read(getJobLevelsUseCaseProvider),
        ref.read(createJobLevelUseCaseProvider),
        ref.read(updateJobLevelUseCaseProvider),
        ref.read(deleteJobLevelUseCaseProvider),
      );
    });

// Convenience providers
final jobLevelListProvider = Provider<List<JobLevel>>((ref) {
  return ref.watch(jobLevelNotifierProvider).items;
});

final jobLevelCreatingProvider = Provider<bool>((ref) {
  return ref.watch(jobLevelCreateStateProvider).isCreating;
});

final jobLevelCreateErrorProvider = Provider<String?>((ref) {
  return ref.watch(jobLevelCreateStateProvider).error;
});
