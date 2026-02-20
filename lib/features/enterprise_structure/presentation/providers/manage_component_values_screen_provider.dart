import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
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
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

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

  void initializeLevel(String levelCode) {
    final orgState = _ref.read(orgUnitsProvider(levelCode));
    if (orgState.isLoading || orgState.hasError || orgState.units.isNotEmpty || orgState.levelCode != null) return;

    final activeLevels = _ref.read(activeLevelsProvider);
    if (activeLevels.levels.isEmpty) return;

    final level = activeLevels.levels.firstWhere(
      (l) => l.levelCode == levelCode,
      orElse: () => activeLevels.levels.first,
    );
    _ref
        .read(orgUnitsProvider(levelCode).notifier)
        .loadOrgUnits(levelCode, structureId: level.structureId, page: 1, pageSize: 10);
  }

  void handleSearch(String levelCode, String query) {
    state = state.copyWith(orgUnitsSearchQuery: query);

    _debouncer.run(() {
      _ref.read(orgUnitsProvider(levelCode).notifier).search(query);
    });
  }

  void setOrgUnitsSearchQuery(String query) {
    state = state.copyWith(orgUnitsSearchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(orgUnitsSearchQuery: '');
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

final manageComponentValuesScreenProvider =
    StateNotifierProvider.autoDispose<ManageComponentValuesScreenNotifier, ManageComponentValuesScreenState>((ref) {
      return ManageComponentValuesScreenNotifier(ref);
    });
