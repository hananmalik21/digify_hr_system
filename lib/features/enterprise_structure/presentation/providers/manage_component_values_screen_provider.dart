import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageComponentValuesScreenState {
  final String? selectedLevelCode;
  final String orgUnitsSearchQuery;

  const ManageComponentValuesScreenState({this.selectedLevelCode, this.orgUnitsSearchQuery = ''});

  ManageComponentValuesScreenState copyWith({String? selectedLevelCode, String? orgUnitsSearchQuery}) {
    return ManageComponentValuesScreenState(
      selectedLevelCode: selectedLevelCode ?? this.selectedLevelCode,
      orgUnitsSearchQuery: orgUnitsSearchQuery ?? this.orgUnitsSearchQuery,
    );
  }
}

class ManageComponentValuesScreenNotifier extends StateNotifier<ManageComponentValuesScreenState> {
  final Ref _ref;

  ManageComponentValuesScreenNotifier(this._ref) : super(const ManageComponentValuesScreenState());

  void selectTreeView() {
    state = state.copyWith(selectedLevelCode: null, orgUnitsSearchQuery: '');
    final cvState = _ref.read(componentValuesProvider);
    if (!cvState.isTreeView) {
      _ref.read(componentValuesProvider.notifier).toggleTreeView();
    }
  }

  void selectLevel(ActiveStructureLevel level) {
    if (_ref.read(componentValuesProvider).isTreeView) {
      _ref.read(componentValuesProvider.notifier).toggleTreeView();
    }
    _ref.read(componentValuesProvider.notifier).filterByType(null);
    state = state.copyWith(selectedLevelCode: level.levelCode, orgUnitsSearchQuery: '');
    _ref.read(orgUnitsProvider(level.levelCode).notifier).loadOrgUnits(level.levelCode, structureId: level.structureId);
  }

  void setOrgUnitsSearchQuery(String query) {
    state = state.copyWith(orgUnitsSearchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(orgUnitsSearchQuery: '');
  }
}

final manageComponentValuesScreenProvider =
    StateNotifierProvider.autoDispose<ManageComponentValuesScreenNotifier, ManageComponentValuesScreenState>((ref) {
      return ManageComponentValuesScreenNotifier(ref);
    });
