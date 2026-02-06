import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_remote_data_source.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:digify_hr_system/features/employee_management/domain/repositories/manage_employees_list_repository.dart';

class ManageEmployeesListRepositoryImpl implements ManageEmployeesListRepository {
  final ManageEmployeesRemoteDataSource remoteDataSource;

  ManageEmployeesListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ManageEmployeesPageResult> getEmployees({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    final dto = await remoteDataSource.getEmployees(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
    return dto.toDomain();
  }

  @override
  Future<Map<String, dynamic>> createEmployee(CreateEmployeeBasicInfoRequest request) async {
    return remoteDataSource.createEmployee(request);
  }
}
