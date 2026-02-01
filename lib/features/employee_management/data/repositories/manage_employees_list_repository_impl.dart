import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_local_data_source.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/domain/repositories/manage_employees_list_repository.dart';

class ManageEmployeesListRepositoryImpl implements ManageEmployeesListRepository {
  final ManageEmployeesLocalDataSource localDataSource;

  ManageEmployeesListRepositoryImpl({required this.localDataSource});

  @override
  Future<List<EmployeeListItem>> getEmployees() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return localDataSource.getEmployees();
  }
}
