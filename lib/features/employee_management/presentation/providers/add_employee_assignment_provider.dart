import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeAssignmentState {
  final Map<String, String?> selectedUnitIds;
  final String? orgUnitIdHex;
  final String? workLocation;

  const AddEmployeeAssignmentState({this.selectedUnitIds = const {}, this.orgUnitIdHex, this.workLocation});

  bool isStepValid(Iterable<String> requiredLevelCodes) {
    for (final code in requiredLevelCodes) {
      final value = selectedUnitIds[code];
      if (value == null || value.trim().isEmpty) return false;
    }
    final loc = workLocation?.trim() ?? '';
    return loc.isNotEmpty;
  }

  AddEmployeeAssignmentState copyWith({
    Map<String, String?>? selectedUnitIds,
    String? orgUnitIdHex,
    String? workLocation,
    bool clearOrgUnitIdHex = false,
    bool clearWorkLocation = false,
  }) {
    return AddEmployeeAssignmentState(
      selectedUnitIds: selectedUnitIds ?? this.selectedUnitIds,
      orgUnitIdHex: clearOrgUnitIdHex ? null : (orgUnitIdHex ?? this.orgUnitIdHex),
      workLocation: clearWorkLocation ? null : (workLocation ?? this.workLocation),
    );
  }
}

class AddEmployeeAssignmentNotifier extends StateNotifier<AddEmployeeAssignmentState> {
  AddEmployeeAssignmentNotifier() : super(const AddEmployeeAssignmentState());

  void setSelection(String levelCode, String? unitId) {
    final newMap = Map<String, String?>.from(state.selectedUnitIds);
    newMap[levelCode] = unitId;
    state = state.copyWith(selectedUnitIds: newMap, orgUnitIdHex: unitId);
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
