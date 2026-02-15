import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/core/services/initialization/app_initialization_service.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';

final appInitializationServiceProvider = Provider<AppInitializationService>((ref) {
  final getEnterprisesUseCase = ref.watch(getEnterprisesUseCaseProvider);
  final getActiveLevelsUseCase = ref.watch(getActiveLevelsUseCaseProvider);
  final orgStructureLevelRemoteDataSource = ref.watch(orgStructureLevelRemoteDataSourceProvider);
  Future<void> loadAbsLookups(int tenantId) => ref.read(absLookupsNotifierProvider.notifier).fetch(tenantId);
  Future<void> loadAbsLookupValues(int tenantId) =>
      ref.read(absLookupValuesByCodeProvider.notifier).fetchForTenant(tenantId);
  void onActiveEnterpriseReady(int? id) {
    if (id != null) {
      ref.read(activeEnterpriseIdNotifierProvider.notifier).setActiveEnterpriseId(id);
    }
  }

  void preloadOrgStructureForEnterprise(int enterpriseId) {
    final notifier = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId).notifier);
    notifier.fetchOrgStructureByEnterpriseId(enterpriseId).then((_) {
      final state = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId));
      if (state.allStructures.isNotEmpty && state.orgStructure == null) {
        notifier.selectStructure(state.allStructures.first.structureId);
      }
    });
  }

  return AppInitializationService(
    getEnterprisesUseCase: getEnterprisesUseCase,
    getActiveLevelsUseCase: getActiveLevelsUseCase,
    orgStructureLevelRemoteDataSource: orgStructureLevelRemoteDataSource,
    loadAbsLookups: loadAbsLookups,
    loadAbsLookupValues: loadAbsLookupValues,
    onActiveEnterpriseReady: onActiveEnterpriseReady,
    preloadOrgStructureForEnterprise: preloadOrgStructureForEnterprise,
  );
});

final enterprisesCacheProvider = Provider<List<Enterprise>?>((ref) {
  return ref.watch(appInitializationServiceProvider).enterprises;
});

final enterprisesCacheStateProvider = Provider<EnterprisesState>((ref) {
  ref.watch(appInitializationAfterAuthProvider);
  final enterprises = ref.watch(enterprisesCacheProvider);
  return EnterprisesState(enterprises: enterprises ?? [], isLoading: enterprises == null, hasError: false);
});

final activeLevelsCacheProvider = Provider<List<ActiveStructureLevel>?>((ref) {
  return ref.watch(appInitializationServiceProvider).activeLevels;
});

class ActiveEnterpriseIdNotifier extends StateNotifier<int?> {
  ActiveEnterpriseIdNotifier() : super(null);

  void setActiveEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}

final activeEnterpriseIdNotifierProvider = StateNotifierProvider<ActiveEnterpriseIdNotifier, int?>((ref) {
  return ActiveEnterpriseIdNotifier();
});

final activeEnterpriseIdProvider = Provider<int?>((ref) {
  return ref.watch(activeEnterpriseIdNotifierProvider);
});

final appInitializationAfterAuthProvider = FutureProvider<void>((ref) async {
  await ref
      .read(appInitializationServiceProvider)
      .initializeAfterAuth(onEnterprisesLoaded: () => ref.invalidate(enterprisesCacheProvider));
  ref.invalidate(enterprisesCacheProvider);
});
