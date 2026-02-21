import 'package:digify_hr_system/core/enums/enterprise_structure_enums.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/active_levels_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/component_values_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/add_org_unit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageComponentValuesScreenState {
  final OrganizationLevel? selectedLevel;
  final String orgUnitsSearchQuery;
  final bool isProcessing;

  const ManageComponentValuesScreenState({
    this.selectedLevel,
    this.orgUnitsSearchQuery = '',
    this.isProcessing = false,
  });

  ManageComponentValuesScreenState copyWith({
    OrganizationLevel? Function()? selectedLevel,
    String? orgUnitsSearchQuery,
    bool? isProcessing,
  }) {
    return ManageComponentValuesScreenState(
      selectedLevel: selectedLevel != null ? selectedLevel() : this.selectedLevel,
      orgUnitsSearchQuery: orgUnitsSearchQuery ?? this.orgUnitsSearchQuery,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class ManageComponentValuesScreenNotifier extends StateNotifier<ManageComponentValuesScreenState> {
  final Ref _ref;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  ManageComponentValuesScreenNotifier(this._ref) : super(const ManageComponentValuesScreenState());

  void selectTreeView() {
    state = state.copyWith(selectedLevel: () => null, orgUnitsSearchQuery: '');
    final cvState = _ref.read(componentValuesProvider);
    if (!cvState.isTreeView) {
      _ref.read(componentValuesProvider.notifier).toggleTreeView();
    }
  }

  void selectLevel(ActiveStructureLevel level) {
    if (_ref.read(componentValuesProvider).isTreeView) {
      _ref.read(componentValuesProvider.notifier).toggleTreeView();
    }
    _ref.read(componentValuesProvider.notifier).filterByType(null, isTreeView: false);
    state = state.copyWith(selectedLevel: () => OrganizationLevel.fromCode(level.levelCode), orgUnitsSearchQuery: '');
    _ref.read(orgUnitsProvider(level.levelCode).notifier).loadOrgUnits(level.levelCode, structureId: level.structureId);
  }

  void initializeLevel(OrganizationLevel level) {
    final levelCode = level.code;
    final orgState = _ref.read(orgUnitsProvider(levelCode));
    if (orgState.isLoading || orgState.hasError || orgState.units.isNotEmpty || orgState.levelCode != null) return;

    final activeLevels = _ref.read(activeLevelsProvider);
    if (activeLevels.levels.isEmpty) return;

    final activeLevel = activeLevels.levels.firstWhere(
      (l) => l.levelCode == levelCode,
      orElse: () => activeLevels.levels.first,
    );
    _ref
        .read(orgUnitsProvider(levelCode).notifier)
        .loadOrgUnits(levelCode, structureId: activeLevel.structureId, page: 1, pageSize: 10);
  }

  void handleSearch(String levelCode, String query) {
    state = state.copyWith(orgUnitsSearchQuery: query);

    _debouncer.run(() {
      _ref.read(orgUnitsProvider(levelCode).notifier).search(query);
    });
  }

  Future<void> deleteOrgUnit(BuildContext context, OrganizationLevel level, OrgStructureLevel unit) async {
    state = state.copyWith(isProcessing: true);
    try {
      final activeLevels = _ref.read(activeLevelsProvider);
      if (activeLevels.levels.isEmpty) {
        ToastService.error(context, 'No active levels available');
        return;
      }
      final activeLevel = activeLevels.levels.firstWhere(
        (l) => l.levelCode == level.code,
        orElse: () => activeLevels.levels.first,
      );

      final deleteUseCase = _ref.read(deleteOrgUnitUseCaseProvider);
      await deleteUseCase.call(activeLevel.structureId, unit.orgUnitId, hard: true);

      if (context.mounted) {
        ToastService.success(context, '${unit.orgUnitNameEn} deleted successfully');
        _ref.read(orgUnitsProvider(level.code).notifier).refresh();
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete: ${e.toString()}');
      }
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }

  void handleAddOrgUnit(BuildContext context, OrganizationLevel level) {
    final activeLevels = _ref.read(activeLevelsProvider);
    if (activeLevels.levels.isEmpty) {
      ToastService.error(context, 'No active levels available');
      return;
    }
    final activeLevel = activeLevels.levels.firstWhere(
      (l) => l.levelCode == level.code,
      orElse: () => activeLevels.levels.first,
    );
    AddOrgUnitDialog.show(context, structureId: activeLevel.structureId, levelCode: level.code);
  }

  void handleEditOrgUnit(BuildContext context, OrganizationLevel level, OrgStructureLevel unit) {
    final activeLevels = _ref.read(activeLevelsProvider);
    if (activeLevels.levels.isEmpty) {
      ToastService.error(context, 'No active levels available');
      return;
    }
    final activeLevel = activeLevels.levels.firstWhere(
      (l) => l.levelCode == level.code,
      orElse: () => activeLevels.levels.first,
    );
    AddOrgUnitDialog.show(context, structureId: activeLevel.structureId, levelCode: level.code, initialValue: unit);
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
