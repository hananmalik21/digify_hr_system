import 'package:digify_hr_system/core/services/initialization/providers/initialization_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _preloadOrgStructureForEnterprise(Ref ref, int enterpriseId) {
  final notifier = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId).notifier);
  notifier.fetchOrgStructureByEnterpriseId(enterpriseId).then((_) {
    final state = ref.read(enterpriseOrgStructureNotifierProvider(enterpriseId));
    if (state.allStructures.isNotEmpty && state.orgStructure == null) {
      notifier.selectStructure(state.allStructures.first.structureId);
    }
  });
}

final activeEnterpriseOrgStructurePreloadProvider = Provider<void>((ref) {
  final current = ref.read(activeEnterpriseIdProvider);
  if (current != null) {
    _preloadOrgStructureForEnterprise(ref, current);
  }
  ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
    if (next == null) return;
    _preloadOrgStructureForEnterprise(ref, next);
  });
});
