import 'package:digify_hr_system/features/workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/data/repositories/org_structure_repository_impl.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/org_structure_repository.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dependency Injection Providers
final orgStructureRemoteDataSourceProvider =
    Provider<OrgStructureRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return OrgStructureRemoteDataSourceImpl(apiClient: apiClient);
    });

final orgStructureRepositoryProvider = Provider<OrgStructureRepository>((ref) {
  return OrgStructureRepositoryImpl(
    remoteDataSource: ref.read(orgStructureRemoteDataSourceProvider),
  );
});

final getActiveOrgStructureLevelsUseCaseProvider =
    Provider<GetActiveOrgStructureLevelsUseCase>((ref) {
      return GetActiveOrgStructureLevelsUseCase(
        repository: ref.read(orgStructureRepositoryProvider),
      );
    });

// State Notifier Provider
final orgStructureNotifierProvider =
    StateNotifierProvider<OrgStructureNotifier, OrgStructureState>((ref) {
      return OrgStructureNotifier(
        getActiveOrgStructureLevelsUseCase: ref.read(
          getActiveOrgStructureLevelsUseCaseProvider,
        ),
      );
    });

// Convenience Providers
final orgStructureLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orgStructureNotifierProvider).isLoading;
});

final orgStructureErrorProvider = Provider<String?>((ref) {
  return ref.watch(orgStructureNotifierProvider).error;
});

final orgStructureActiveLevelsProvider = Provider((ref) {
  final orgStructure = ref.watch(orgStructureNotifierProvider).orgStructure;
  return orgStructure?.activeLevels ?? [];
});
