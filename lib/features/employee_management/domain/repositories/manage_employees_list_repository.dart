import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';

abstract class ManageEmployeesListRepository {
  Future<List<EmployeeListItem>> getEmployees();
}
