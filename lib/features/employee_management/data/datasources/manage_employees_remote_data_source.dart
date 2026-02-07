import 'package:dio/dio.dart';
import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/employee_management/data/datasources/manage_employees_mock_data.dart';
import 'package:digify_hr_system/features/employee_management/data/dto/employees_response_dto.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/document.dart';

abstract class ManageEmployeesRemoteDataSource {
  Future<EmployeesResponseDto> getEmployees({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> createEmployee(CreateEmployeeBasicInfoRequest request, {Document? document});
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
  Future<Map<String, dynamic>> createEmployee(CreateEmployeeBasicInfoRequest request, {Document? document}) async {
    final map = <String, dynamic>{
      'first_name_en': request.firstNameEn?.trim() ?? '',
      'last_name_en': request.lastNameEn?.trim() ?? '',
      'middle_name_en': request.middleNameEn?.trim() ?? '',
      'first_name_ar': request.firstNameAr?.trim() ?? '',
      'last_name_ar': request.lastNameAr?.trim() ?? '',
      'middle_name_ar': request.middleNameAr?.trim() ?? '',
      'email': request.email?.trim() ?? '',
      'phone_number': request.phoneNumber?.trim() ?? '',
      'date_of_birth': request.dateOfBirth != null
          ? CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.dateOfBirth!)
          : '',
      'emerg_address': request.emergAddress?.trim() ?? '',
      'emerg_phone': request.emergPhone?.trim() ?? '',
      'emerg_email': request.emergEmail?.trim() ?? '',
      'relationship': request.emergRelationship?.trim() ?? '',
      'contact_name': request.contactName?.trim() ?? '',
      if (request.workScheduleId != null) 'work_schedule_id': request.workScheduleId!,
      if (request.enterpriseId != null) 'enterprise_id': request.enterpriseId!,
      if (request.orgUnitIdHex != null && request.orgUnitIdHex!.isNotEmpty)
        'org_unit_id_hex': request.orgUnitIdHex!.trim(),
      'address_line1': request.workLocation?.trim() ?? '',
      'address_line2': request.workLocation?.trim() ?? '',
      'city': request.workLocation?.trim() ?? '',
      'area': request.workLocation?.trim() ?? '',
      'country_code': request.workLocation?.trim() ?? '',
      'civil_id_number': request.civilIdNumber?.trim() ?? '',
      'passport_number': request.passportNumber?.trim() ?? '',
      if (request.positionIdHex != null && request.positionIdHex!.isNotEmpty)
        'position_id_hex': request.positionIdHex!.trim(),
      if (request.enterpriseHireDate != null)
        'enterprise_hire_date': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.enterpriseHireDate!),
      if (request.jobFamilyId != null) 'job_family_id': request.jobFamilyId!,
      if (request.jobLevelId != null) 'job_level_id': request.jobLevelId!,
      if (request.gradeId != null) 'grade_id': request.gradeId!,
      if (request.probationDays != null) 'probation_days': request.probationDays!,
      if (request.contractTypeCode != null && request.contractTypeCode!.isNotEmpty)
        'contract_type_code': request.contractTypeCode!.trim(),
      if (request.employmentStatusCode != null && request.employmentStatusCode!.isNotEmpty)
        'employment_status': request.employmentStatusCode!.trim(),
      if (request.basicSalaryKwd != null && request.basicSalaryKwd!.trim().isNotEmpty)
        'basic_salary_kwd': request.basicSalaryKwd!.trim(),
      if (request.housingKwd != null && request.housingKwd!.trim().isNotEmpty)
        'housing_kwd': request.housingKwd!.trim(),
      if (request.transportKwd != null && request.transportKwd!.trim().isNotEmpty)
        'transport_kwd': request.transportKwd!.trim(),
      if (request.foodKwd != null && request.foodKwd!.trim().isNotEmpty) 'food_kwd': request.foodKwd!.trim(),
      if (request.mobileKwd != null && request.mobileKwd!.trim().isNotEmpty) 'mobile_kwd': request.mobileKwd!.trim(),
      if (request.otherKwd != null && request.otherKwd!.trim().isNotEmpty) 'other_kwd': request.otherKwd!.trim(),
      if (request.accountNumber != null && request.accountNumber!.trim().isNotEmpty)
        'account_number': request.accountNumber!.trim(),
      if (request.iban != null && request.iban!.trim().isNotEmpty) 'iban': request.iban!.trim(),
      if (request.civilIdExpiry != null)
        'civil_id_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.civilIdExpiry!),
      if (request.passportExpiry != null)
        'passport_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.passportExpiry!),
      if (request.visaNumber != null && request.visaNumber!.trim().isNotEmpty)
        'visa_number': request.visaNumber!.trim(),
      if (request.visaExpiry != null)
        'visa_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.visaExpiry!),
      if (request.workPermitNumber != null && request.workPermitNumber!.trim().isNotEmpty)
        'work_permit_number': request.workPermitNumber!.trim(),
      if (request.workPermitExpiry != null)
        'work_permit_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.workPermitExpiry!),
      ..._lookupCodesToFormFields(request.lookupCodesByTypeCode),
    };
    final formData = FormData.fromMap(map);
    if (document != null && (document.path.contains('/') || document.path.contains(r'\'))) {
      formData.files.add(MapEntry('document', await MultipartFile.fromFile(document.path, filename: document.name)));
    }
    return apiClient.postMultipart(ApiEndpoints.createEmployee, formData: formData);
  }

  static Map<String, dynamic> _lookupCodesToFormFields(Map<String, String?>? lookupCodesByTypeCode) {
    if (lookupCodesByTypeCode == null || lookupCodesByTypeCode.isEmpty) return {};
    final result = <String, dynamic>{};
    for (final entry in lookupCodesByTypeCode.entries) {
      final value = entry.value?.trim();
      if (value != null && value.isNotEmpty) {
        final apiKey = CreateEmployeeBasicInfoRequest.typeCodeToApiKey(entry.key);
        result[apiKey] = value;
      }
    }
    return result;
  }
}
