import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseSelectionState {
  final Map<String, OrgUnit?> selections;
  final Map<String, List<OrgUnit>> availableOptions;
  final Map<String, bool> loadingStates;
  final Map<String, String?> errors;
  final int? structureId;

  const EnterpriseSelectionState({
    this.selections = const {},
    this.availableOptions = const {},
    this.loadingStates = const {},
    this.errors = const {},
    this.structureId,
  });

  EnterpriseSelectionState copyWith({
    Map<String, OrgUnit?>? selections,
    Map<String, List<OrgUnit>>? availableOptions,
    Map<String, bool>? loadingStates,
    Map<String, String?>? errors,
    int? structureId,
  }) {
    return EnterpriseSelectionState(
      selections: selections ?? this.selections,
      availableOptions: availableOptions ?? this.availableOptions,
      loadingStates: loadingStates ?? this.loadingStates,
      errors: errors ?? this.errors,
      structureId: structureId ?? this.structureId,
    );
  }

  OrgUnit? getSelection(String levelCode) => selections[levelCode];

  List<OrgUnit> getOptions(String levelCode) =>
      availableOptions[levelCode] ?? [];

  bool isLoading(String levelCode) => loadingStates[levelCode] ?? false;

  String? getError(String levelCode) => errors[levelCode];
}

class EnterpriseSelectionNotifier
    extends StateNotifier<EnterpriseSelectionState> {
  final GetOrgUnitsByLevelUseCase getOrgUnitsByLevelUseCase;
  final List<OrgStructureLevel> levels;

  EnterpriseSelectionNotifier({
    required this.getOrgUnitsByLevelUseCase,
    required this.levels,
    required int structureId,
  }) : super(EnterpriseSelectionState(structureId: structureId));

  Future<void> loadOptionsForLevel(String levelCode) async {
    if (state.structureId == null) return;

    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = true;
    state = state.copyWith(loadingStates: newLoadingStates);

    try {
      final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);
      int? parentOrgUnitId;

      if (levelIndex > 0) {
        final parentLevel = levels[levelIndex - 1];
        final parentSelection = state.getSelection(parentLevel.levelCode);
        parentOrgUnitId = parentSelection?.orgUnitId;

        if (parentOrgUnitId == null) {
          final newOptions = Map<String, List<OrgUnit>>.from(
            state.availableOptions,
          );
          newOptions[levelCode] = [];
          final newLoadingStates = Map<String, bool>.from(state.loadingStates);
          newLoadingStates[levelCode] = false;
          state = state.copyWith(
            availableOptions: newOptions,
            loadingStates: newLoadingStates,
          );
          return;
        }
      }

      final response = await getOrgUnitsByLevelUseCase(
        structureId: state.structureId!,
        levelCode: levelCode,
        parentOrgUnitId: parentOrgUnitId,
      );

      final activeUnits = response.data.where((unit) => unit.isActive).toList();

      final newOptions = Map<String, List<OrgUnit>>.from(
        state.availableOptions,
      );
      newOptions[levelCode] = activeUnits;

      final newLoadingStates = Map<String, bool>.from(state.loadingStates);
      newLoadingStates[levelCode] = false;

      final newErrors = Map<String, String?>.from(state.errors);
      newErrors[levelCode] = null;

      state = state.copyWith(
        availableOptions: newOptions,
        loadingStates: newLoadingStates,
        errors: newErrors,
      );
    } catch (e) {
      final newLoadingStates = Map<String, bool>.from(state.loadingStates);
      newLoadingStates[levelCode] = false;

      final newErrors = Map<String, String?>.from(state.errors);
      newErrors[levelCode] = e.toString();

      state = state.copyWith(
        loadingStates: newLoadingStates,
        errors: newErrors,
      );
    }
  }

  void selectUnit(String levelCode, OrgUnit? unit) {
    final newSelections = Map<String, OrgUnit?>.from(state.selections);
    newSelections[levelCode] = unit;

    final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);

    for (int i = levelIndex + 1; i < levels.length; i++) {
      final childLevelCode = levels[i].levelCode;
      newSelections[childLevelCode] = null;
    }

    final newOptions = Map<String, List<OrgUnit>>.from(state.availableOptions);
    for (int i = levelIndex + 1; i < levels.length; i++) {
      final childLevelCode = levels[i].levelCode;
      newOptions[childLevelCode] = [];
    }

    state = state.copyWith(
      selections: newSelections,
      availableOptions: newOptions,
    );
  }

  void reset() {
    state = EnterpriseSelectionState(structureId: state.structureId);
  }
}
