import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/services/pagination_service.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/job_family_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/job_family_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_family_repository.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_job_families_usecase.dart';

// Providers for dependency injection
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final jobFamilyRemoteDataSourceProvider = Provider<JobFamilyRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return JobFamilyRemoteDataSourceImpl(apiClient: apiClient);
});

final jobFamilyRepositoryProvider = Provider<JobFamilyRepository>((ref) {
  return JobFamilyRepositoryImpl(
    remoteDataSource: ref.read(jobFamilyRemoteDataSourceProvider),
  );
});

final getJobFamiliesUseCaseProvider = Provider<GetJobFamiliesUseCase>((ref) {
  return GetJobFamiliesUseCase(
    repository: ref.read(jobFamilyRepositoryProvider),
  );
});

// Job Family Notifier with pagination
class JobFamilyNotifier extends StateNotifier<PaginationState<JobFamily>>
    with PaginationMixin<JobFamily>
    implements PaginationController<JobFamily> {
  final GetJobFamiliesUseCase _getJobFamiliesUseCase;

  JobFamilyNotifier(this._getJobFamiliesUseCase)
    : super(const PaginationState());

  @override
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = handleLoadingState(state, true);

    try {
      final response = await _getJobFamiliesUseCase(
        page: 1,
        pageSize: state.pageSize,
      );

      final jobFamilies = response.data
          .map((data) => data.toJobFamily())
          .toList();

      state = handleSuccessState(
        currentState: state,
        newItems: jobFamilies,
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
      final response = await _getJobFamiliesUseCase(
        page: nextPage,
        pageSize: state.pageSize,
      );

      final jobFamilies = response.data
          .map((data) => data.toJobFamily())
          .toList();

      state = handleSuccessState(
        currentState: state,
        newItems: jobFamilies,
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

  void updatePageSize(int newPageSize) {
    if (newPageSize != state.pageSize) {
      state = state.copyWith(pageSize: newPageSize);
      refresh();
    }
  }
}

// Provider for the notifier
final jobFamilyNotifierProvider =
    StateNotifierProvider<JobFamilyNotifier, PaginationState<JobFamily>>((ref) {
      return JobFamilyNotifier(ref.read(getJobFamiliesUseCaseProvider));
    });

// Convenience providers
final jobFamilyListProvider = Provider<List<JobFamily>>((ref) {
  return ref.watch(jobFamilyNotifierProvider).items;
});

final jobFamilyLoadingProvider = Provider<bool>((ref) {
  return ref.watch(jobFamilyNotifierProvider).isLoading;
});

final jobFamilyErrorProvider = Provider<String?>((ref) {
  return ref.watch(jobFamilyNotifierProvider).errorMessage;
});

/// Extension to easily access job family providers
extension JobFamilyProviderExtensions on WidgetRef {
  void refreshJobFamilies() {
    read(jobFamilyNotifierProvider.notifier).refresh();
  }

  void loadMoreJobFamilies() {
    read(jobFamilyNotifierProvider.notifier).loadNextPage();
  }
}
