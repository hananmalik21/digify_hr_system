import 'package:dio/dio.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_mock_data.dart';
import 'package:digify_hr_system/features/employee_management/data/dto/employees_response_dto.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/create_employee_basic_info_request.dart';

abstract class ManageEmployeesRemoteDataSource {
  Future<EmployeesResponseDto> getEmployees({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> createEmployee(CreateEmployeeBasicInfoRequest request);
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

  @override
  Future<Map<String, dynamic>> createEmployee(CreateEmployeeBasicInfoRequest request) async {
    final map = <String, dynamic>{
      'first_name_en': request.firstNameEn?.trim() ?? '',
      'last_name_en': request.lastNameEn?.trim() ?? '',
      'middle_name_en': request.middleNameEn?.trim() ?? '',
      'first_name_ar': request.firstNameAr?.trim() ?? '',
      'last_name_ar': request.lastNameAr?.trim() ?? '',
      'middle_name_ar': request.middleNameAr?.trim() ?? '',
      'email': request.email?.trim() ?? '',
      'phone_number': request.phoneNumber?.trim() ?? '',
      'mobile_number': request.mobileNumber?.trim() ?? '',
      'date_of_birth': request.dateOfBirth != null
          ? CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.dateOfBirth!)
          : '',
      'emerg_address': request.emergAddress?.trim() ?? '',
      'emerg_phone': request.emergPhone?.trim() ?? '',
      'emerg_email': request.emergEmail?.trim() ?? '',
      'relationship': request.emergRelationship?.trim() ?? '',
      'contact_name': request.contactName?.trim() ?? '',
      if (request.workScheduleId != null) 'work_schedule_id': request.workScheduleId!,
      if (request.orgUnitIdHex != null && request.orgUnitIdHex!.isNotEmpty)
        'org_unit_id_hex': request.orgUnitIdHex!.trim(),
      'work_location_id': 1,
    };
    final formData = FormData.fromMap(map);
    return apiClient.postMultipart(ApiEndpoints.createEmployee, formData: formData);
  }
}
