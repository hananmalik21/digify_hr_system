import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/services/initialization/app_initialization_service.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';

final appInitializationServiceProvider = Provider<AppInitializationService>((ref) {
  final getEnterprisesUseCase = ref.watch(getEnterprisesUseCaseProvider);
  final getActiveLevelsUseCase = ref.watch(getActiveLevelsUseCaseProvider);
  final orgStructureLevelRemoteDataSource = ref.watch(orgStructureLevelRemoteDataSourceProvider);

  return AppInitializationService(
    getEnterprisesUseCase: getEnterprisesUseCase,
    getActiveLevelsUseCase: getActiveLevelsUseCase,
    orgStructureLevelRemoteDataSource: orgStructureLevelRemoteDataSource,
  );
});

final enterprisesCacheProvider = Provider<List<Enterprise>?>((ref) {
  final service = ref.watch(appInitializationServiceProvider);
  return service.enterprises;
});

final enterprisesCacheStateProvider = Provider<EnterprisesState>((ref) {
  final enterprises = ref.watch(enterprisesCacheProvider);
  return EnterprisesState(enterprises: enterprises ?? [], isLoading: enterprises == null, hasError: false);
});

final activeLevelsCacheProvider = Provider<List<ActiveStructureLevel>?>((ref) {
  final service = ref.watch(appInitializationServiceProvider);
  return service.activeLevels;
});

final activeEnterpriseIdProvider = Provider<int?>((ref) {
  final service = ref.watch(appInitializationServiceProvider);
  return service.activeEnterpriseId;
});
