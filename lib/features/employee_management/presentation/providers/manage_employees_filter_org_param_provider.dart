import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_org_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageEmployeesFilterOrgParamProvider =
    Provider.family<({List<OrgStructureLevel> levels, String structureId})?, int>((ref, enterpriseId) {
      final state = ref.watch(manageEmployeesOrgStructureNotifierProvider(enterpriseId));
      final org = state.orgStructure;
      if (org == null) return null;
      return (levels: org.activeLevels, structureId: org.structureId);
    });
