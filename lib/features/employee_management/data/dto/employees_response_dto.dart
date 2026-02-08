import 'package:digify_hr_system/features/employee_management/domain/models/active_flag_enum.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/assignment_status_enum.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/contract_type_code_enum.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_status_enum.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';

class EmployeesResponseDto {
  final bool success;
  final String? message;
  final PaginationMetaDto meta;
  final List<EmployeeListItemDto> data;

  const EmployeesResponseDto({required this.success, this.message, required this.meta, required this.data});

  factory EmployeesResponseDto.fromJson(Map<String, dynamic> json) {
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List<dynamic>? ?? [];
    return EmployeesResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      meta: PaginationMetaDto.fromJson(paginationJson),
      data: dataList.map((e) => EmployeeListItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  ManageEmployeesPageResult toDomain() {
    return ManageEmployeesPageResult(
      items: data.map((e) => e.toDomain()).toList(),
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

class OrgStructureItemDto {
  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String levelCode;
  final String? status;
  final String? isActive;

  const OrgStructureItemDto({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    required this.levelCode,
    this.status,
    this.isActive,
  });

  factory OrgStructureItemDto.fromJson(Map<String, dynamic> json) {
    return OrgStructureItemDto(
      level: (json['level'] as num?)?.toInt() ?? 0,
      orgUnitId: json['org_unit_id'] as String? ?? '',
      orgUnitCode: json['org_unit_code'] as String? ?? '',
      orgUnitNameEn: json['org_unit_name_en'] as String?,
      orgUnitNameAr: json['org_unit_name_ar'] as String?,
      levelCode: json['level_code'] as String? ?? '',
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }
}

class PositionObjDto {
  final String? positionId;
  final String? positionCode;
  final String? positionTitleEn;
  final String? positionTitleAr;
  final String? status;

  const PositionObjDto({this.positionId, this.positionCode, this.positionTitleEn, this.positionTitleAr, this.status});

  factory PositionObjDto.fromJson(Map<String, dynamic> json) {
    return PositionObjDto(
      positionId: json['position_id'] as String?,
      positionCode: json['position_code'] as String?,
      positionTitleEn: json['position_title_en'] as String?,
      positionTitleAr: json['position_title_ar'] as String?,
      status: json['status'] as String?,
    );
  }
}

class EmployeeListItemDto {
  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
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
  final String? employeeStatus;
  final String? employeeIsActive;
  final String? creationDate;
  final String? lastUpdateDate;
  final int? assignmentId;
  final String? assignmentGuid;
  final String? employeeNumber;
  final String? orgUnitId;
  final List<OrgStructureItemDto> orgStructureList;
  final int? workLocationId;
  final String? positionId;
  final PositionObjDto? positionObj;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final String? enterpriseHireDate;
  final String? contractTypeCode;
  final int? probationDays;
  final int? reportingToEmpId;
  final String? employmentStatus;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? assignmentStatus;
  final String? assignmentIsActive;
  final int? rn;

  const EmployeeListItemDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
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
    this.employeeStatus,
    this.employeeIsActive,
    this.creationDate,
    this.lastUpdateDate,
    this.assignmentId,
    this.assignmentGuid,
    this.employeeNumber,
    this.orgUnitId,
    this.orgStructureList = const [],
    this.workLocationId,
    this.positionId,
    this.positionObj,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.enterpriseHireDate,
    this.contractTypeCode,
    this.probationDays,
    this.reportingToEmpId,
    this.employmentStatus,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.assignmentStatus,
    this.assignmentIsActive,
    this.rn,
  });

  factory EmployeeListItemDto.fromJson(Map<String, dynamic> json) {
    final orgList = json['org_structure_list'] as List<dynamic>? ?? [];
    final positionObjJson = json['position_obj'] as Map<String, dynamic>?;
    return EmployeeListItemDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: json['employee_guid'] as String? ?? '',
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
      employeeStatus: json['employee_status'] as String?,
      employeeIsActive: json['employee_is_active'] as String?,
      creationDate: json['creation_date'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
      assignmentId: (json['assignment_id'] as num?)?.toInt(),
      assignmentGuid: json['assignment_guid'] as String?,
      employeeNumber: json['employee_number'] as String?,
      orgUnitId: json['org_unit_id'] as String?,
      orgStructureList: orgList.map((e) => OrgStructureItemDto.fromJson(e as Map<String, dynamic>)).toList(),
      workLocationId: (json['work_location_id'] as num?)?.toInt(),
      positionId: json['position_id'] as String?,
      positionObj: positionObjJson != null ? PositionObjDto.fromJson(positionObjJson) : null,
      jobFamilyId: (json['job_family_id'] as num?)?.toInt(),
      jobLevelId: (json['job_level_id'] as num?)?.toInt(),
      gradeId: (json['grade_id'] as num?)?.toInt(),
      enterpriseHireDate: json['enterprise_hire_date'] as String?,
      contractTypeCode: json['contract_type_code'] as String?,
      probationDays: (json['probation_days'] as num?)?.toInt(),
      reportingToEmpId: (json['reporting_to_emp_id'] as num?)?.toInt(),
      employmentStatus: json['employment_status'] as String?,
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      assignmentStatus: json['assignment_status'] as String?,
      assignmentIsActive: json['assignment_is_active'] as String?,
      rn: (json['rn'] as num?)?.toInt(),
    );
  }

  EmployeeListItem toDomain() {
    final nameParts = [firstNameEn, middleNameEn, lastNameEn].whereType<String>().where((s) => s.trim().isNotEmpty);
    final fullName = nameParts.join(' ').trim();
    final status = EmployeeStatus.fromRaw(employeeStatus ?? employmentStatus);
    final department = _departmentFromOrgStructure();
    final position = positionObj?.positionTitleEn?.trim() ?? '';
    return EmployeeListItem(
      id: employeeGuid.isNotEmpty ? employeeGuid : '$employeeId',
      employeeIdNum: employeeId,
      fullName: fullName.isEmpty ? 'Employee $employeeId' : fullName,
      employeeNumber: employeeNumber ?? 'EMP-$employeeId',
      position: position,
      positionId: positionId,
      department: department,
      status: status.raw.isEmpty ? (employeeStatus ?? employmentStatus ?? '') : status.raw,
      employeeStatus: status,
      email: email,
      phone: phoneNumber ?? mobileNumber,
      assignmentId: assignmentId,
      assignmentGuid: assignmentGuid,
      orgUnitId: orgUnitId,
      contractTypeCode: ContractTypeCode.fromRaw(contractTypeCode),
      employmentStatus: AssignmentStatus.fromRaw(employmentStatus ?? employeeStatus),
      employeeIsActive: ActiveFlag.fromRaw(employeeIsActive),
    );
  }

  String _departmentFromOrgStructure() {
    const departmentLevel = 'DEPARTMENT';
    for (final item in orgStructureList) {
      if (item.levelCode == departmentLevel && (item.orgUnitNameEn?.trim().isNotEmpty ?? false)) {
        return item.orgUnitNameEn!.trim();
      }
    }
    if (orgStructureList.isNotEmpty) {
      final last = orgStructureList.last;
      return last.orgUnitNameEn?.trim() ?? '';
    }
    return '';
  }
}
