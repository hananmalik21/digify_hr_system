import 'package:digify_hr_system/features/workforce_structure/data/datasources/workforce_stats_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/workforce_stats_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/workforce_stats_repository.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_workforce_stats_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final workforceStatsRemoteDataSourceProvider = Provider<WorkforceStatsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkforceStatsRemoteDataSourceImpl(apiClient: apiClient);
});

final workforceStatsRepositoryProvider = Provider<WorkforceStatsRepository>((ref) {
  return WorkforceStatsRepositoryImpl(remoteDataSource: ref.read(workforceStatsRemoteDataSourceProvider));
});

final getWorkforceStatsUseCaseProvider = Provider<GetWorkforceStatsUseCase>((ref) {
  return GetWorkforceStatsUseCase(repository: ref.read(workforceStatsRepositoryProvider));
});

// State Provider using AsyncNotifier
final workforceStatsNotifierProvider = AsyncNotifierProvider<WorkforceStatsNotifier, WorkforceStats?>(() {
  return WorkforceStatsNotifier();
});

class WorkforceStatsNotifier extends AsyncNotifier<WorkforceStats?> {
  @override
  Future<WorkforceStats?> build() async {
    final useCase = ref.read(getWorkforceStatsUseCaseProvider);
    return await useCase();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final useCase = ref.read(getWorkforceStatsUseCaseProvider);
    state = await AsyncValue.guard(() => useCase());
  }
}

// Convenience provider to get the stats value
final workforceStatsProvider = Provider<WorkforceStats?>((ref) {
  final asyncValue = ref.watch(workforceStatsNotifierProvider);
  return asyncValue.value;
});
