import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_remote_data_source.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/data/repositories/manage_employees_list_repository_impl.dart';
import 'package:digify_hr_system/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_filters_state.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final manageEmployeesRemoteDataSourceProvider = Provider<ManageEmployeesRemoteDataSource>((ref) {
  return ManageEmployeesRemoteDataSourceImpl(apiClient: ref.watch(_apiClientProvider));
});

final manageEmployeesListRepositoryProvider = Provider<ManageEmployeesListRepository>((ref) {
  return ManageEmployeesListRepositoryImpl(remoteDataSource: ref.watch(manageEmployeesRemoteDataSourceProvider));
});

class ManageEmployeesListNotifier extends Notifier<ManageEmployeesListState> {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  Debouncer? _searchDebouncer;

  @override
  ManageEmployeesListState build() {
    ref.onDispose(() {
      _searchDebouncer?.dispose();
      _searchDebouncer = null;
    });
    ref.listen<int?>(manageEmployeesEnterpriseIdProvider, (previous, next) {
      if (previous != null && next != previous) {
        state = state.copyWith(items: [], pagination: null, searchQuery: null, lastEnterpriseId: next);
      } else if (next != null) {
        state = state.copyWith(lastEnterpriseId: next);
      }
    });
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    return ManageEmployeesListState(lastEnterpriseId: enterpriseId);
  }

  void setSearchQueryInput(String value) {
    _searchDebouncer ??= Debouncer(delay: _searchDebounceDuration);
    final trimmed = value.trim();
    _searchDebouncer!.run(() => search(trimmed));
  }

  Future<void> loadPage(int enterpriseId, int page, {int pageSize = 10, String? search}) async {
    final effectiveSearch = search ?? state.searchQuery;
    state = state.copyWith(
      isLoading: true,
      error: null,
      lastEnterpriseId: enterpriseId,
      currentPage: page,
      searchQuery: effectiveSearch,
    );
    final filters = ref.read(manageEmployeesFiltersProvider);
    final repository = ref.read(manageEmployeesListRepositoryProvider);
    final result = await repository.getEmployees(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: effectiveSearch,
      assignmentStatus: filters.assignmentStatus?.raw,
      positionId: filters.positionId,
      jobFamilyId: filters.jobFamilyId,
      jobLevelId: filters.jobLevelId,
      gradeId: filters.gradeId,
      orgUnitId: filters.orgUnitId,
      levelCode: filters.levelCode,
    );
    state = state.copyWith(
      items: result.items,
      pagination: result.pagination,
      isLoading: false,
      error: null,
      searchQuery: effectiveSearch,
    );
  }

  /// Applies search immediately (e.g. on submit). Cancels any pending debounced search.
  void search(String query) {
    _searchDebouncer?.dispose();
    _searchDebouncer = null;
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) return;
    final q = query.trim();
    if (q.isEmpty) {
      state = state.copyWith(items: [], pagination: null, searchQuery: null, isLoading: false, error: null);
      return;
    }
    loadPage(enterpriseId, 1, search: q);
  }

  Future<void> goToPage(int page, {int pageSize = 10}) async {
    final enterpriseId = state.lastEnterpriseId;
    if (enterpriseId == null) return;
    await loadPage(enterpriseId, page, pageSize: pageSize);
  }

  Future<void> refresh() async {
    final enterpriseId = state.lastEnterpriseId;
    if (enterpriseId == null) return;
    await loadPage(enterpriseId, state.currentPage);
  }

  void prependEmployee(EmployeeListItem item) {
    state = state.copyWith(items: [item, ...state.items]);
  }

  void replaceEmployee(EmployeeListItem updatedItem) {
    final id = updatedItem.id;
    if (id.isEmpty) return;
    final items = state.items.map((e) => e.id == id ? updatedItem : e).toList();
    state = state.copyWith(items: items);
  }
}

final manageEmployeesListProvider = NotifierProvider<ManageEmployeesListNotifier, ManageEmployeesListState>(
  ManageEmployeesListNotifier.new,
);
