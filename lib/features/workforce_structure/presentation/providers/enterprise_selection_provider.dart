import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseSelectionState {
  final Map<String, OrgUnit?> selections;
  final Map<String, List<OrgUnit>> availableOptions;
  final Map<String, bool> loadingStates;
  final Map<String, bool> fetchingMoreStates;
  final Map<String, String?> errors;
  final Map<String, int> pages;
  final Map<String, bool> hasNextStates;
  final Map<String, String> searchQueries;
  final String? structureId;

  const EnterpriseSelectionState({
    this.selections = const {},
    this.availableOptions = const {},
    this.loadingStates = const {},
    this.fetchingMoreStates = const {},
    this.errors = const {},
    this.pages = const {},
    this.hasNextStates = const {},
    this.searchQueries = const {},
    this.structureId,
  });

  EnterpriseSelectionState copyWith({
    Map<String, OrgUnit?>? selections,
    Map<String, List<OrgUnit>>? availableOptions,
    Map<String, bool>? loadingStates,
    Map<String, bool>? fetchingMoreStates,
    Map<String, String?>? errors,
    Map<String, int>? pages,
    Map<String, bool>? hasNextStates,
    Map<String, String>? searchQueries,
    String? structureId,
  }) {
    return EnterpriseSelectionState(
      selections: selections ?? this.selections,
      availableOptions: availableOptions ?? this.availableOptions,
      loadingStates: loadingStates ?? this.loadingStates,
      fetchingMoreStates: fetchingMoreStates ?? this.fetchingMoreStates,
      errors: errors ?? this.errors,
      pages: pages ?? this.pages,
      hasNextStates: hasNextStates ?? this.hasNextStates,
      searchQueries: searchQueries ?? this.searchQueries,
      structureId: structureId ?? this.structureId,
    );
  }

  OrgUnit? getSelection(String levelCode) => selections[levelCode];

  List<OrgUnit> getOptions(String levelCode) => availableOptions[levelCode] ?? [];

  bool isLoading(String levelCode) => loadingStates[levelCode] ?? false;

  bool isFetchingMore(String levelCode) => fetchingMoreStates[levelCode] ?? false;

  String? getError(String levelCode) => errors[levelCode];

  int getPage(String levelCode) => pages[levelCode] ?? 1;

  bool hasNext(String levelCode) => hasNextStates[levelCode] ?? false;

  String getSearchQuery(String levelCode) => searchQueries[levelCode] ?? '';
}

class EnterpriseSelectionNotifier extends StateNotifier<EnterpriseSelectionState> {
  final GetOrgUnitsByLevelUseCase getOrgUnitsByLevelUseCase;
  final List<OrgStructureLevel> levels;
  final _debouncer = Debouncer();

  EnterpriseSelectionNotifier({
    required this.getOrgUnitsByLevelUseCase,
    required this.levels,
    required String structureId,
  }) : super(EnterpriseSelectionState(structureId: structureId));

  Future<void> loadOptionsForLevel(String levelCode) async {
    if (state.structureId == null) return;

    final newPages = Map<String, int>.from(state.pages);
    newPages[levelCode] = 1;

    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = true;
    state = state.copyWith(loadingStates: newLoadingStates, pages: newPages);

    try {
      final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);
      String? parentOrgUnitId;

      if (levelIndex > 0) {
        final parentLevel = levels[levelIndex - 1];
        final parentSelection = state.getSelection(parentLevel.levelCode);
        parentOrgUnitId = parentSelection?.orgUnitId;

        if (parentOrgUnitId == null) {
          _updateStateAfterSuccess(levelCode, [], false);
          return;
        }
      }

      final response = await getOrgUnitsByLevelUseCase(
        structureId: state.structureId!,
        levelCode: levelCode,
        parentOrgUnitId: parentOrgUnitId,
        search: state.getSearchQuery(levelCode),
        page: 1,
        pageSize: 10,
      );

      final activeUnits = response.data.where((unit) => unit.isActive).toList();
      _updateStateAfterSuccess(levelCode, activeUnits, response.hasNext);
    } catch (e) {
      _updateStateAfterError(levelCode, e.toString());
    }
  }

  Future<void> loadMoreOptionsForLevel(String levelCode) async {
    if (state.structureId == null ||
        state.isLoading(levelCode) ||
        state.isFetchingMore(levelCode) ||
        !state.hasNext(levelCode)) {
      return;
    }

    final nextPage = state.getPage(levelCode) + 1;

    final newFetchingMoreStates = Map<String, bool>.from(state.fetchingMoreStates);
    newFetchingMoreStates[levelCode] = true;
    state = state.copyWith(fetchingMoreStates: newFetchingMoreStates);

    try {
      final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);
      String? parentOrgUnitId;

      if (levelIndex > 0) {
        final parentLevel = levels[levelIndex - 1];
        final parentSelection = state.getSelection(parentLevel.levelCode);
        parentOrgUnitId = parentSelection?.orgUnitId;
      }

      final response = await getOrgUnitsByLevelUseCase(
        structureId: state.structureId!,
        levelCode: levelCode,
        parentOrgUnitId: parentOrgUnitId,
        search: state.getSearchQuery(levelCode),
        page: nextPage,
        pageSize: 10,
      );

      final activeUnits = response.data.where((unit) => unit.isActive).toList();
      final currentOptions = state.getOptions(levelCode);
      final allOptions = [...currentOptions, ...activeUnits];

      final newPages = Map<String, int>.from(state.pages);
      newPages[levelCode] = nextPage;

      final newHasNextStates = Map<String, bool>.from(state.hasNextStates);
      newHasNextStates[levelCode] = response.hasNext;

      final newOptions = Map<String, List<OrgUnit>>.from(state.availableOptions);
      newOptions[levelCode] = allOptions;

      final newFetchingMoreStates = Map<String, bool>.from(state.fetchingMoreStates);
      newFetchingMoreStates[levelCode] = false;

      state = state.copyWith(
        availableOptions: newOptions,
        pages: newPages,
        hasNextStates: newHasNextStates,
        fetchingMoreStates: newFetchingMoreStates,
      );
    } catch (e) {
      final newFetchingMoreStates = Map<String, bool>.from(state.fetchingMoreStates);
      newFetchingMoreStates[levelCode] = false;
      state = state.copyWith(fetchingMoreStates: newFetchingMoreStates);
    }
  }

  void _updateStateAfterSuccess(String levelCode, List<OrgUnit> options, bool hasNext) {
    final newOptions = Map<String, List<OrgUnit>>.from(state.availableOptions);
    newOptions[levelCode] = options;

    final newHasNextStates = Map<String, bool>.from(state.hasNextStates);
    newHasNextStates[levelCode] = hasNext;

    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = false;

    final newErrors = Map<String, String?>.from(state.errors);
    newErrors[levelCode] = null;

    state = state.copyWith(
      availableOptions: newOptions,
      hasNextStates: newHasNextStates,
      loadingStates: newLoadingStates,
      errors: newErrors,
    );
  }

  void _updateStateAfterError(String levelCode, String error) {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    newLoadingStates[levelCode] = false;

    final newErrors = Map<String, String?>.from(state.errors);
    newErrors[levelCode] = error;

    state = state.copyWith(loadingStates: newLoadingStates, errors: newErrors);
  }

  void setSearchQuery(String levelCode, String query) {
    if (state.getSearchQuery(levelCode) == query) return;

    final newSearchQueries = Map<String, String>.from(state.searchQueries);
    newSearchQueries[levelCode] = query;
    state = state.copyWith(searchQueries: newSearchQueries);

    _debouncer.run(() {
      loadOptionsForLevel(levelCode);
    });
  }

  void clearSearch(String levelCode) {
    setSearchQuery(levelCode, '');
  }

  void selectUnit(String levelCode, OrgUnit? unit) {
    final newSelections = Map<String, OrgUnit?>.from(state.selections);
    newSelections[levelCode] = unit;

    final levelIndex = levels.indexWhere((l) => l.levelCode == levelCode);

    final newOptions = Map<String, List<OrgUnit>>.from(state.availableOptions);
    final newPages = Map<String, int>.from(state.pages);
    final newHasNextStates = Map<String, bool>.from(state.hasNextStates);

    for (int i = levelIndex + 1; i < levels.length; i++) {
      final childLevelCode = levels[i].levelCode;
      newSelections[childLevelCode] = null;
      newOptions[childLevelCode] = [];
      newPages[childLevelCode] = 1;
      newHasNextStates[childLevelCode] = false;
    }

    state = state.copyWith(
      selections: newSelections,
      availableOptions: newOptions,
      pages: newPages,
      hasNextStates: newHasNextStates,
    );
  }

  void initialize(Map<String, OrgUnit> selections) {
    state = state.copyWith(selections: selections);
  }

  void reset() {
    state = EnterpriseSelectionState(structureId: state.structureId);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
