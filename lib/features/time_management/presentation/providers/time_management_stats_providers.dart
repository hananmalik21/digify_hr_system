import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/time_management_stats_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/data/repositories/time_management_stats_repository_impl.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_management_stats.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/time_management_stats_repository.dart';
import 'package:digify_hr_system/features/time_management/domain/usecases/get_time_management_stats_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final timeManagementStatsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final timeManagementStatsRemoteDataSourceProvider = Provider<TimeManagementStatsRemoteDataSource>((ref) {
  final apiClient = ref.watch(timeManagementStatsApiClientProvider);
  return TimeManagementStatsRemoteDataSourceImpl(apiClient: apiClient);
});

final timeManagementStatsRepositoryProvider = Provider<TimeManagementStatsRepository>((ref) {
  return TimeManagementStatsRepositoryImpl(remoteDataSource: ref.read(timeManagementStatsRemoteDataSourceProvider));
});

final getTimeManagementStatsUseCaseProvider = Provider<GetTimeManagementStatsUseCase>((ref) {
  return GetTimeManagementStatsUseCase(repository: ref.read(timeManagementStatsRepositoryProvider));
});

// State Provider using AsyncNotifier
final timeManagementStatsNotifierProvider = AsyncNotifierProvider<TimeManagementStatsNotifier, TimeManagementStats?>(
  () {
    return TimeManagementStatsNotifier();
  },
);

class TimeManagementStatsNotifier extends AsyncNotifier<TimeManagementStats?> {
  @override
  Future<TimeManagementStats?> build() async {
    final useCase = ref.read(getTimeManagementStatsUseCaseProvider);
    return await useCase();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final useCase = ref.read(getTimeManagementStatsUseCaseProvider);
    state = await AsyncValue.guard(() => useCase());
  }
}
