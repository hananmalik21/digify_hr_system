import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addEmployeeOrgSelectionKeyProvider =
    Provider.autoDispose<({String structureId, List<OrgStructureLevel> levels})?>((ref) {
      final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
      if (enterpriseId == null) return null;

      final orgState = ref.watch(enterpriseOrgStructureNotifierProvider(enterpriseId));
      final structureId = orgState.orgStructure?.structureId;
      final levels = orgState.orgStructure?.activeLevels ?? <OrgStructureLevel>[];

      if (structureId == null || structureId.isEmpty || levels.isEmpty) return null;
      return (structureId: structureId, levels: levels);
    });

final addEmployeeOrgSelectionProvider = StateNotifierProvider.autoDispose
    .family<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState,
      ({String structureId, List<OrgStructureLevel> levels})
    >((ref, param) {
      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: param.levels,
        structureId: param.structureId,
      );
    });
