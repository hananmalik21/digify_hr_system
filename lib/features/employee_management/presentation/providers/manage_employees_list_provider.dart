import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_local_data_source.dart';
import 'package:digify_hr_system/features/employee_management/data/repositories/manage_employees_list_repository_impl.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final manageEmployeesLocalDataSourceProvider = Provider<ManageEmployeesLocalDataSource>((ref) {
  return ManageEmployeesLocalDataSourceImpl();
});

final manageEmployeesListRepositoryProvider = Provider<ManageEmployeesListRepository>((ref) {
  return ManageEmployeesListRepositoryImpl(localDataSource: ref.watch(manageEmployeesLocalDataSourceProvider));
});

class ManageEmployeesListNotifier extends AsyncNotifier<List<EmployeeListItem>> {
  @override
  Future<List<EmployeeListItem>> build() async {
    final repository = ref.watch(manageEmployeesListRepositoryProvider);
    return repository.getEmployees();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(manageEmployeesListRepositoryProvider);
      return repository.getEmployees();
    });
  }
}

final manageEmployeesListProvider = AsyncNotifierProvider<ManageEmployeesListNotifier, List<EmployeeListItem>>(
  ManageEmployeesListNotifier.new,
);
