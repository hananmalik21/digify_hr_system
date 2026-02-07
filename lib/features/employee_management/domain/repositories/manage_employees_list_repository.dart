import 'package:digify_hr_system/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/document.dart';

abstract class ManageEmployeesListRepository {
  Future<ManageEmployeesPageResult> getEmployees({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> createEmployee(CreateEmployeeBasicInfoRequest request, {Document? document});
}
