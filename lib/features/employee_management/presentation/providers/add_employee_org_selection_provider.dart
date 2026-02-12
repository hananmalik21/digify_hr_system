import 'package:flutter/scheduler.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_assignment_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_org_structure_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Map<String, OrgUnit> _selectionsFromAssignment(
  Map<String, LevelSelection> levelSelections,
  List<String> orderedLevelCodes,
  String structureId,
  int enterpriseId,
) {
  final map = <String, OrgUnit>{};
  for (final levelCode in orderedLevelCodes) {
    final ls = levelSelections[levelCode];
    if (ls == null || ls.orgUnitId.isEmpty) continue;
    map[levelCode] = OrgUnit(
      orgUnitId: ls.orgUnitId,
      orgStructureId: structureId,
      enterpriseId: enterpriseId,
      levelCode: levelCode,
      orgUnitCode: '',
      orgUnitNameEn: ls.displayNameEn,
      orgUnitNameAr: '',
      isActive: true,
    );
  }
  return map;
}

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
      final notifier = EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: param.levels,
        structureId: param.structureId,
      );
      final assignment = ref.read(addEmployeeAssignmentProvider);
      final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
      if (assignment.levelSelections.isNotEmpty && enterpriseId != null) {
        final orderedLevelCodes = param.levels.map((l) => l.levelCode).toList();
        final selections = _selectionsFromAssignment(
          assignment.levelSelections,
          orderedLevelCodes,
          param.structureId,
          enterpriseId,
        );
        if (selections.isNotEmpty) notifier.initialize(selections);
      }
      return notifier;
    });

final addEmployeeOrgSelectionSyncProvider = Provider.autoDispose<void>((ref) {
  final key = ref.watch(addEmployeeOrgSelectionKeyProvider);
  final assignment = ref.watch(addEmployeeAssignmentProvider);
  if (key == null || assignment.levelSelections.isEmpty) return;
  final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
  if (enterpriseId == null) return;
  final orderedLevelCodes = key.levels.map((l) => l.levelCode).toList();
  final selections = _selectionsFromAssignment(
    assignment.levelSelections,
    orderedLevelCodes,
    key.structureId,
    enterpriseId,
  );
  if (selections.isEmpty) return;
  final selectionState = ref.read(addEmployeeOrgSelectionProvider(key));
  final notifierAlreadyHasSelection = orderedLevelCodes.every((levelCode) {
    final assigned = assignment.levelSelections[levelCode];
    if (assigned == null) return true;
    final current = selectionState.getSelection(levelCode);
    return current != null && current.orgUnitId == assigned.orgUnitId;
  });
  if (notifierAlreadyHasSelection) return;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    ref.read(addEmployeeOrgSelectionProvider(key).notifier).initialize(selections);
  });
});
