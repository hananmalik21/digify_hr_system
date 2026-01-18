import 'package:digify_hr_system/features/workforce_structure/domain/models/employee.dart';

class EmployeeDto {
  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String email;
  final String? phoneNumber;
  final String? mobileNumber;
  final DateTime? dateOfBirth;
  final String status;
  final String isActive;
  final DateTime createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  const EmployeeDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    required this.email,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    required this.status,
    required this.isActive,
    required this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      employeeId: (json['employee_id'] as num).toInt(),
      employeeGuid: json['employee_guid'] as String,
      enterpriseId: (json['enterprise_id'] as num).toInt(),
      firstName: json['first_name'] as String? ?? '',
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String? ?? '',
      firstNameAr: json['first_name_ar'] as String?,
      middleNameAr: json['middle_name_ar'] as String?,
      lastNameAr: json['last_name_ar'] as String?,
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth'] as String) : null,
      status: json['status'] as String? ?? '',
      isActive: json['is_active'] as String? ?? 'N',
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      updatedBy: json['updated_by'] as String?,
    );
  }

  Employee toDomain() {
    return Employee(
      id: employeeId,
      guid: employeeGuid,
      enterpriseId: enterpriseId,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      firstNameAr: firstNameAr,
      middleNameAr: middleNameAr,
      lastNameAr: lastNameAr,
      email: email,
      phoneNumber: phoneNumber,
      mobileNumber: mobileNumber,
      dateOfBirth: dateOfBirth,
      status: status,
      isActive: isActive == 'Y',
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
    );
  }
}
