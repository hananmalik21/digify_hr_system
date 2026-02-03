import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_mock_data.dart';
import 'package:digify_hr_system/features/employee_management/data/dto/employees_response_dto.dart';

abstract class ManageEmployeesRemoteDataSource {
  Future<EmployeesResponseDto> getEmployees({required int enterpriseId, int page = 1, int pageSize = 10});
}

class ManageEmployeesRemoteDataSourceImpl implements ManageEmployeesRemoteDataSource {
  ManageEmployeesRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<EmployeesResponseDto> getEmployees({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final response = await apiClient.get(ApiEndpoints.employees, queryParameters: queryParameters);
      return EmployeesResponseDto.fromJson(response);
    } catch (_) {
      return getManageEmployeesMockResponse();
    }
  }
}
