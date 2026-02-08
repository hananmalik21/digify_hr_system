import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_config.dart';
import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_remote_data_source.dart';
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
  @override
  ManageEmployeesListState build() {
    ref.listen<int?>(manageEmployeesEnterpriseIdProvider, (previous, next) {
      if (next != null) {
        Future.microtask(() => loadPage(next, 1));
      }
    });
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId != null) {
      Future.microtask(() => loadPage(enterpriseId, 1));
    }
    return const ManageEmployeesListState();
  }

  Future<void> loadPage(int enterpriseId, int page, {int pageSize = 10}) async {
    state = state.copyWith(isLoading: true, error: null, lastEnterpriseId: enterpriseId, currentPage: page);
    final filters = ref.read(manageEmployeesFiltersProvider);
    final repository = ref.read(manageEmployeesListRepositoryProvider);
    final result = await repository.getEmployees(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      positionId: filters.positionId,
      jobFamilyId: filters.jobFamilyId,
      jobLevelId: filters.jobLevelId,
      gradeId: filters.gradeId,
      orgUnitId: filters.orgUnitId,
      levelCode: filters.levelCode,
    );
    state = state.copyWith(items: result.items, pagination: result.pagination, isLoading: false, error: null);
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
}

final manageEmployeesListProvider = NotifierProvider<ManageEmployeesListNotifier, ManageEmployeesListState>(
  ManageEmployeesListNotifier.new,
);
