import 'package:flutter_riverpod/flutter_riverpod.dart';

class LevelSelection {
  final String orgUnitId;
  final String displayNameEn;

  const LevelSelection({required this.orgUnitId, required this.displayNameEn});
}

class AddEmployeeAssignmentState {
  final Map<String, LevelSelection> levelSelections;
  final String? orgUnitIdHex;
  final String? workLocation;

  const AddEmployeeAssignmentState({this.levelSelections = const {}, this.orgUnitIdHex, this.workLocation});

  String? getSelectedUnitId(String levelCode) => levelSelections[levelCode]?.orgUnitId;

  String? getDisplayName(String levelCode) => levelSelections[levelCode]?.displayNameEn;

  Map<String, String?> get selectedUnitIds =>
      Map.fromEntries(levelSelections.entries.map((e) => MapEntry(e.key, e.value.orgUnitId)));

  bool isStepValid(Iterable<String> requiredLevelCodes) {
    for (final code in requiredLevelCodes) {
      final id = getSelectedUnitId(code);
      if (id == null || id.trim().isEmpty) return false;
    }
    final loc = workLocation?.trim() ?? '';
    return loc.isNotEmpty;
  }

  AddEmployeeAssignmentState copyWith({
    Map<String, LevelSelection>? levelSelections,
    String? orgUnitIdHex,
    String? workLocation,
    bool clearOrgUnitIdHex = false,
    bool clearWorkLocation = false,
  }) {
    return AddEmployeeAssignmentState(
      levelSelections: levelSelections ?? this.levelSelections,
      orgUnitIdHex: clearOrgUnitIdHex ? null : (orgUnitIdHex ?? this.orgUnitIdHex),
      workLocation: clearWorkLocation ? null : (workLocation ?? this.workLocation),
    );
  }
}

class AddEmployeeAssignmentNotifier extends StateNotifier<AddEmployeeAssignmentState> {
  AddEmployeeAssignmentNotifier() : super(const AddEmployeeAssignmentState());

  void setSelection(String levelCode, String unitId, String displayNameEn, {required List<String> orderedLevelCodes}) {
    final newSelections = Map<String, LevelSelection>.from(state.levelSelections);
    newSelections[levelCode] = LevelSelection(orgUnitId: unitId, displayNameEn: displayNameEn);

    final levelIndex = orderedLevelCodes.indexOf(levelCode);
    if (levelIndex >= 0) {
      for (var i = levelIndex + 1; i < orderedLevelCodes.length; i++) {
        newSelections.remove(orderedLevelCodes[i]);
      }
    }

    state = state.copyWith(levelSelections: newSelections, orgUnitIdHex: unitId);
  }

  void setWorkLocation(String? value) {
    state = state.copyWith(workLocation: value, clearWorkLocation: value == null || value.isEmpty);
  }

  void reset() {
    state = const AddEmployeeAssignmentState();
  }
}

final addEmployeeAssignmentProvider = StateNotifierProvider<AddEmployeeAssignmentNotifier, AddEmployeeAssignmentState>((
  ref,
) {
  return AddEmployeeAssignmentNotifier();
});
