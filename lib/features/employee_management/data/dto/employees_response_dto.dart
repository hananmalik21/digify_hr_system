import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';

class EmployeesResponseDto {
  final bool success;
  final String? message;
  final PaginationMetaDto meta;
  final List<ManageEmployeeItemDto> data;

  const EmployeesResponseDto({required this.success, this.message, required this.meta, required this.data});

  factory EmployeesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];
    return EmployeesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: PaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => ManageEmployeeItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  ManageEmployeesPageResult toDomain() {
    return ManageEmployeesPageResult(
      items: data.map((e) => e.toEmployeeListItem()).toList(),
      pagination: meta.toPaginationInfo(),
    );
  }
}

class PaginationMetaDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationMetaDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) {
    return PaginationMetaDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: json['has_next'] as bool? ?? false,
      hasPrevious: json['has_previous'] as bool? ?? false,
    );
  }

  PaginationInfo toPaginationInfo() {
    return PaginationInfo(
      currentPage: page,
      totalPages: totalPages,
      totalItems: total,
      pageSize: pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }
}

class ManageEmployeeItemDto {
  final int employeeId;
  final String employeeGuid;
  final int? tenantId;
  final int? enterpriseId;
  final String? firstNameEn;
  final String? middleNameEn;
  final String? lastNameEn;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String? familyNameAr;
  final String? email;
  final String? phoneNumber;
  final String? mobileNumber;
  final String? dateOfBirth;
  final String status;
  final String? isActive;
  final String? createdBy;

  const ManageEmployeeItemDto({
    required this.employeeId,
    required this.employeeGuid,
    this.tenantId,
    this.enterpriseId,
    this.firstNameEn,
    this.middleNameEn,
    this.lastNameEn,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    this.familyNameAr,
    this.email,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    required this.status,
    this.isActive,
    this.createdBy,
  });

  factory ManageEmployeeItemDto.fromJson(Map<String, dynamic> json) {
    return ManageEmployeeItemDto(
      employeeId: (json['employee_id'] as num).toInt(),
      employeeGuid: json['employee_guid'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt(),
      enterpriseId: (json['enterprise_id'] as num?)?.toInt(),
      firstNameEn: json['first_name_en'] as String?,
      middleNameEn: json['middle_name_en'] as String?,
      lastNameEn: json['last_name_en'] as String?,
      firstNameAr: json['first_name_ar'] as String?,
      middleNameAr: json['middle_name_ar'] as String?,
      lastNameAr: json['last_name_ar'] as String?,
      familyNameAr: json['family_name_ar'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      status: json['status'] as String? ?? '',
      isActive: json['is_active'] as String?,
      createdBy: json['created_by'] as String?,
    );
  }

  EmployeeListItem toEmployeeListItem() {
    final parts = [firstNameEn, middleNameEn, lastNameEn].whereType<String>().where((s) => s.trim().isNotEmpty);
    final fullName = parts.join(' ').trim();
    return EmployeeListItem(
      id: employeeGuid.isNotEmpty ? employeeGuid : '$employeeId',
      fullName: fullName.isEmpty ? 'Employee $employeeId' : fullName,
      employeeId: 'EMP$employeeId',
      position: '',
      department: '',
      status: status.isNotEmpty ? status.toLowerCase() : '',
      email: email,
      phone: phoneNumber ?? mobileNumber,
    );
  }
}
