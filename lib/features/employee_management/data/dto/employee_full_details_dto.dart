import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';

class EmployeeFullDetailsResponseDto {
  EmployeeFullDetailsResponseDto({required this.data});

  factory EmployeeFullDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return EmployeeFullDetailsResponseDto(data: data != null ? EmployeeFullDetailsDataDto.fromJson(data) : null);
  }

  final EmployeeFullDetailsDataDto? data;

  EmployeeFullDetails? toDomain() => data?.toDomain();
}

class EmployeeFullDetailsDataDto {
  EmployeeFullDetailsDataDto({
    this.employee,
    this.assignment,
    this.demographics,
    this.workSchedule,
    this.compensation,
    this.allowances,
    this.documentCompliance,
    this.documents = const [],
    this.emergencyContacts = const [],
    this.bankAccounts = const [],
    this.addresses = const [],
  });

  factory EmployeeFullDetailsDataDto.fromJson(Map<String, dynamic> json) {
    return EmployeeFullDetailsDataDto(
      employee: _parseMap(json['employee'], EmployeeDetailSectionDto.fromJson),
      assignment: _parseMap(json['assignment'], AssignmentDetailSectionDto.fromJson),
      demographics: _parseMap(json['demographics'], DemographicsDetailSectionDto.fromJson),
      workSchedule: _parseMap(json['work_schedule'], WorkScheduleDetailSectionDto.fromJson),
      compensation: _parseMap(json['compensation'], CompensationDetailSectionDto.fromJson),
      allowances: _parseMap(json['allowances'], AllowancesDetailSectionDto.fromJson),
      documentCompliance: _parseMap(json['document_compliance'], DocumentComplianceDetailSectionDto.fromJson),
      documents: _parseList(json['documents'], DocumentItemDto.fromJson),
      emergencyContacts: _parseList(json['emergency_contacts'], EmergencyContactItemDto.fromJson),
      bankAccounts: _parseList(json['bank_accounts'], BankAccountItemDto.fromJson),
      addresses: _parseList(json['addresses'], AddressItemDto.fromJson),
    );
  }

  static T? _parseMap<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) {
    if (v is! Map<String, dynamic>) return null;
    return fromJson(v);
  }

  static List<T> _parseList<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) {
    if (v is! List) return [];
    return v.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  final EmployeeDetailSectionDto? employee;
  final AssignmentDetailSectionDto? assignment;
  final DemographicsDetailSectionDto? demographics;
  final WorkScheduleDetailSectionDto? workSchedule;
  final CompensationDetailSectionDto? compensation;
  final AllowancesDetailSectionDto? allowances;
  final DocumentComplianceDetailSectionDto? documentCompliance;
  final List<DocumentItemDto> documents;
  final List<EmergencyContactItemDto> emergencyContacts;
  final List<BankAccountItemDto> bankAccounts;
  final List<AddressItemDto> addresses;

  EmployeeFullDetails? toDomain() {
    if (employee == null || assignment == null) return null;
    return EmployeeFullDetails(
      employee: employee!.toDomain(),
      assignment: assignment!.toDomain(),
      demographics: demographics?.toDomain(),
      workSchedule: workSchedule?.toDomain(),
      compensation: compensation?.toDomain(),
      allowances: allowances?.toDomain(),
      documentCompliance: documentCompliance?.toDomain(),
      documents: documents.map((e) => e.toDomain()).toList(),
      emergencyContacts: emergencyContacts.map((e) => e.toDomain()).toList(),
      bankAccounts: bankAccounts.map((e) => e.toDomain()).toList(),
      addresses: addresses.map((e) => e.toDomain()).toList(),
    );
  }
}

class EmployeeDetailSectionDto {
  EmployeeDetailSectionDto({
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
    this.employeeNumber,
    this.workLocationId,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.probationDays,
    this.reportingToEmpId,
  });

  factory EmployeeDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailSectionDto(
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
      employeeNumber: json['employee_number'] as String?,
      workLocationId: (json['work_location_id'] as num?)?.toInt(),
      jobFamilyId: (json['job_family_id'] as num?)?.toInt(),
      jobLevelId: (json['job_level_id'] as num?)?.toInt(),
      gradeId: (json['grade_id'] as num?)?.toInt(),
      probationDays: (json['probation_days'] as num?)?.toInt(),
      reportingToEmpId: (json['reporting_to_emp_id'] as num?)?.toInt(),
    );
  }

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
  final String? employeeNumber;
  final int? workLocationId;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final int? probationDays;
  final int? reportingToEmpId;

  EmployeeDetailSection toDomain() => EmployeeDetailSection(
    enterpriseId: enterpriseId,
    employeeId: employeeId,
    employeeGuid: employeeGuid,
    firstNameEn: firstNameEn,
    middleNameEn: middleNameEn,
    lastNameEn: lastNameEn,
    firstNameAr: firstNameAr,
    middleNameAr: middleNameAr,
    lastNameAr: lastNameAr,
    familyNameAr: familyNameAr,
    email: email,
    phoneNumber: phoneNumber,
    mobileNumber: mobileNumber,
    dateOfBirth: dateOfBirth,
    employeeStatus: employeeStatus,
    employeeIsActive: employeeIsActive,
    employeeNumber: employeeNumber,
    workLocationId: workLocationId,
    jobFamilyId: jobFamilyId,
    jobLevelId: jobLevelId,
    gradeId: gradeId,
    probationDays: probationDays,
    reportingToEmpId: reportingToEmpId,
  );
}

class AssignmentDetailSectionDto {
  AssignmentDetailSectionDto({
    required this.assignmentId,
    this.assignmentGuid,
    this.orgUnitId,
    this.orgStructureList = const [],
    this.positionId,
    this.enterpriseHireDate,
    this.contractTypeCode,
    this.employmentStatus,
    this.assignmentStatus,
    this.assignmentIsActive,
  });

  factory AssignmentDetailSectionDto.fromJson(Map<String, dynamic> json) {
    final list = json['org_structure_list'];
    return AssignmentDetailSectionDto(
      assignmentId: (json['assignment_id'] as num?)?.toInt() ?? 0,
      assignmentGuid: json['assignment_guid'] as String?,
      orgUnitId: json['org_unit_id'] as String?,
      orgStructureList: list is List
          ? (list).whereType<Map<String, dynamic>>().map(OrgStructureItemDto.fromJson).toList()
          : const [],
      positionId: json['position_id'] as String?,
      enterpriseHireDate: json['enterprise_hire_date'] as String?,
      contractTypeCode: json['contract_type_code'] as String?,
      employmentStatus: json['employment_status'] as String?,
      assignmentStatus: json['assignment_status'] as String?,
      assignmentIsActive: json['assignment_is_active'] as String?,
    );
  }

  final int assignmentId;
  final String? assignmentGuid;
  final String? orgUnitId;
  final List<OrgStructureItemDto> orgStructureList;
  final String? positionId;
  final String? enterpriseHireDate;
  final String? contractTypeCode;
  final String? employmentStatus;
  final String? assignmentStatus;
  final String? assignmentIsActive;

  AssignmentDetailSection toDomain() => AssignmentDetailSection(
    assignmentId: assignmentId,
    assignmentGuid: assignmentGuid,
    orgUnitId: orgUnitId,
    orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
    positionId: positionId,
    enterpriseHireDate: enterpriseHireDate,
    contractTypeCode: contractTypeCode,
    employmentStatus: employmentStatus,
    assignmentStatus: assignmentStatus,
    assignmentIsActive: assignmentIsActive,
  );
}

class OrgStructureItemDto {
  OrgStructureItemDto({
    required this.level,
    required this.orgUnitId,
    this.orgUnitCode,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    this.levelCode,
    this.status,
    this.isActive,
  });

  factory OrgStructureItemDto.fromJson(Map<String, dynamic> json) {
    return OrgStructureItemDto(
      level: (json['level'] as num?)?.toInt() ?? 0,
      orgUnitId: json['org_unit_id'] as String? ?? '',
      orgUnitCode: json['org_unit_code'] as String?,
      orgUnitNameEn: json['org_unit_name_en'] as String?,
      orgUnitNameAr: json['org_unit_name_ar'] as String?,
      levelCode: json['level_code'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int level;
  final String orgUnitId;
  final String? orgUnitCode;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String? levelCode;
  final String? status;
  final String? isActive;

  OrgStructureItem toDomain() => OrgStructureItem(
    level: level,
    orgUnitId: orgUnitId,
    orgUnitCode: orgUnitCode,
    orgUnitNameEn: orgUnitNameEn,
    orgUnitNameAr: orgUnitNameAr,
    levelCode: levelCode,
    status: status,
    isActive: isActive,
  );
}

class DemographicsDetailSectionDto {
  DemographicsDetailSectionDto({
    this.demoId,
    this.demoGuid,
    this.genderCode,
    this.nationalityCode,
    this.maritalStatusCode,
    this.religionCode,
    this.civilIdNumber,
    this.passportNumber,
    this.visaNumber,
    this.visaExpiry,
    this.workPermitNumber,
    this.workPermitExpiry,
  });

  factory DemographicsDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return DemographicsDetailSectionDto(
      demoId: (json['demo_id'] as num?)?.toInt(),
      demoGuid: json['demo_guid'] as String?,
      genderCode: json['gender_code'] as String?,
      nationalityCode: json['nationality_code'] as String?,
      maritalStatusCode: json['marital_status_code'] as String?,
      religionCode: json['religion_code'] as String?,
      civilIdNumber: json['civil_id_number'] as String?,
      passportNumber: json['passport_number'] as String?,
      visaNumber: json['visa_number'] as String?,
      visaExpiry: json['visa_expiry'] as String?,
      workPermitNumber: json['work_permit_number'] as String?,
      workPermitExpiry: json['work_permit_expiry'] as String?,
    );
  }

  final int? demoId;
  final String? demoGuid;
  final String? genderCode;
  final String? nationalityCode;
  final String? maritalStatusCode;
  final String? religionCode;
  final String? civilIdNumber;
  final String? passportNumber;
  final String? visaNumber;
  final String? visaExpiry;
  final String? workPermitNumber;
  final String? workPermitExpiry;

  DemographicsDetailSection toDomain() => DemographicsDetailSection(
    demoId: demoId,
    demoGuid: demoGuid,
    genderCode: genderCode,
    nationalityCode: nationalityCode,
    maritalStatusCode: maritalStatusCode,
    religionCode: religionCode,
    civilIdNumber: civilIdNumber,
    passportNumber: passportNumber,
    visaNumber: visaNumber,
    visaExpiry: visaExpiry,
    workPermitNumber: workPermitNumber,
    workPermitExpiry: workPermitExpiry,
  );
}

class WorkScheduleDetailSectionDto {
  WorkScheduleDetailSectionDto({
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.empSchId,
    this.empSchGuid,
    this.workScheduleId,
    this.wsStart,
    this.wsEnd,
    this.wsStatus,
    this.wsIsActive,
  });

  factory WorkScheduleDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return WorkScheduleDetailSectionDto(
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      empSchId: (json['emp_sch_id'] as num?)?.toInt(),
      empSchGuid: json['emp_sch_guid'] as String?,
      workScheduleId: (json['work_schedule_id'] as num?)?.toInt(),
      wsStart: json['ws_start'] as String?,
      wsEnd: json['ws_end'] as String?,
      wsStatus: json['ws_status'] as String?,
      wsIsActive: json['ws_is_active'] as String?,
    );
  }

  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final int? empSchId;
  final String? empSchGuid;
  final int? workScheduleId;
  final String? wsStart;
  final String? wsEnd;
  final String? wsStatus;
  final String? wsIsActive;

  WorkScheduleDetailSection toDomain() => WorkScheduleDetailSection(
    effectiveStartDate: effectiveStartDate,
    effectiveEndDate: effectiveEndDate,
    empSchId: empSchId,
    empSchGuid: empSchGuid,
    workScheduleId: workScheduleId,
    wsStart: wsStart,
    wsEnd: wsEnd,
    wsStatus: wsStatus,
    wsIsActive: wsIsActive,
  );
}

class CompensationDetailSectionDto {
  CompensationDetailSectionDto({
    this.compId,
    this.compGuid,
    this.basicSalaryKwd,
    this.compStart,
    this.compEnd,
    this.compStatus,
    this.compIsActive,
  });

  factory CompensationDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return CompensationDetailSectionDto(
      compId: (json['comp_id'] as num?)?.toInt(),
      compGuid: json['comp_guid'] as String?,
      basicSalaryKwd: (json['basic_salary_kwd'] as num?)?.toDouble(),
      compStart: json['comp_start'] as String?,
      compEnd: json['comp_end'] as String?,
      compStatus: json['comp_status'] as String?,
      compIsActive: json['comp_is_active'] as String?,
    );
  }

  final int? compId;
  final String? compGuid;
  final double? basicSalaryKwd;
  final String? compStart;
  final String? compEnd;
  final String? compStatus;
  final String? compIsActive;

  CompensationDetailSection toDomain() => CompensationDetailSection(
    compId: compId,
    compGuid: compGuid,
    basicSalaryKwd: basicSalaryKwd,
    compStart: compStart,
    compEnd: compEnd,
    compStatus: compStatus,
    compIsActive: compIsActive,
  );
}

class AllowancesDetailSectionDto {
  AllowancesDetailSectionDto({
    this.allowId,
    this.allowGuid,
    this.housingKwd,
    this.transportKwd,
    this.foodKwd,
    this.mobileKwd,
    this.otherKwd,
    this.allowStart,
    this.allowEnd,
    this.allowStatus,
    this.allowIsActive,
  });

  factory AllowancesDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return AllowancesDetailSectionDto(
      allowId: (json['allow_id'] as num?)?.toInt(),
      allowGuid: json['allow_guid'] as String?,
      housingKwd: (json['housing_kwd'] as num?)?.toDouble(),
      transportKwd: (json['transport_kwd'] as num?)?.toDouble(),
      foodKwd: (json['food_kwd'] as num?)?.toDouble(),
      mobileKwd: (json['mobile_kwd'] as num?)?.toDouble(),
      otherKwd: (json['other_kwd'] as num?)?.toDouble(),
      allowStart: json['allow_start'] as String?,
      allowEnd: json['allow_end'] as String?,
      allowStatus: json['allow_status'] as String?,
      allowIsActive: json['allow_is_active'] as String?,
    );
  }

  final int? allowId;
  final String? allowGuid;
  final double? housingKwd;
  final double? transportKwd;
  final double? foodKwd;
  final double? mobileKwd;
  final double? otherKwd;
  final String? allowStart;
  final String? allowEnd;
  final String? allowStatus;
  final String? allowIsActive;

  AllowancesDetailSection toDomain() => AllowancesDetailSection(
    allowId: allowId,
    allowGuid: allowGuid,
    housingKwd: housingKwd,
    transportKwd: transportKwd,
    foodKwd: foodKwd,
    mobileKwd: mobileKwd,
    otherKwd: otherKwd,
    allowStart: allowStart,
    allowEnd: allowEnd,
    allowStatus: allowStatus,
    allowIsActive: allowIsActive,
  );
}

class DocumentComplianceDetailSectionDto {
  DocumentComplianceDetailSectionDto({
    this.docCompId,
    this.docCompGuid,
    this.civilIdExpiry,
    this.passportExpiry,
    this.doccStatus,
    this.doccIsActive,
  });

  factory DocumentComplianceDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return DocumentComplianceDetailSectionDto(
      docCompId: (json['doc_comp_id'] as num?)?.toInt(),
      docCompGuid: json['doc_comp_guid'] as String?,
      civilIdExpiry: json['civil_id_expiry'] as String?,
      passportExpiry: json['passport_expiry'] as String?,
      doccStatus: json['docc_status'] as String?,
      doccIsActive: json['docc_is_active'] as String?,
    );
  }

  final int? docCompId;
  final String? docCompGuid;
  final String? civilIdExpiry;
  final String? passportExpiry;
  final String? doccStatus;
  final String? doccIsActive;

  DocumentComplianceDetailSection toDomain() => DocumentComplianceDetailSection(
    docCompId: docCompId,
    docCompGuid: docCompGuid,
    civilIdExpiry: civilIdExpiry,
    passportExpiry: passportExpiry,
    doccStatus: doccStatus,
    doccIsActive: doccIsActive,
  );
}

class DocumentItemDto {
  DocumentItemDto({
    required this.documentId,
    this.documentGuid,
    this.documentTypeCode,
    this.fileName,
    this.mimeType,
    this.fileSizeBytes,
    this.status,
    this.isActive,
    this.accessUrl,
  });

  factory DocumentItemDto.fromJson(Map<String, dynamic> json) {
    return DocumentItemDto(
      documentId: (json['document_id'] as num?)?.toInt() ?? 0,
      documentGuid: json['document_guid'] as String?,
      documentTypeCode: json['document_type_code'] as String?,
      fileName: json['file_name'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSizeBytes: (json['file_size_bytes'] as num?)?.toInt(),
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
      accessUrl: json['access_url'] as String?,
    );
  }

  final int documentId;
  final String? documentGuid;
  final String? documentTypeCode;
  final String? fileName;
  final String? mimeType;
  final int? fileSizeBytes;
  final String? status;
  final String? isActive;
  final String? accessUrl;

  DocumentItem toDomain() => DocumentItem(
    documentId: documentId,
    documentGuid: documentGuid,
    documentTypeCode: documentTypeCode,
    fileName: fileName,
    mimeType: mimeType,
    fileSizeBytes: fileSizeBytes,
    status: status,
    isActive: isActive,
    accessUrl: accessUrl,
  );
}

class EmergencyContactItemDto {
  EmergencyContactItemDto({
    required this.emergId,
    this.emergGuid,
    this.contactName,
    this.relationshipCode,
    this.phoneNumber,
    this.email,
    this.address,
    this.status,
    this.isActive,
  });

  factory EmergencyContactItemDto.fromJson(Map<String, dynamic> json) {
    return EmergencyContactItemDto(
      emergId: (json['emerg_id'] as num?)?.toInt() ?? 0,
      emergGuid: json['emerg_guid'] as String?,
      contactName: json['contact_name'] as String?,
      relationshipCode: json['relationship_code'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int emergId;
  final String? emergGuid;
  final String? contactName;
  final String? relationshipCode;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? status;
  final String? isActive;

  EmergencyContactItem toDomain() => EmergencyContactItem(
    emergId: emergId,
    emergGuid: emergGuid,
    contactName: contactName,
    relationshipCode: relationshipCode,
    phoneNumber: phoneNumber,
    email: email,
    address: address,
    status: status,
    isActive: isActive,
  );
}

class BankAccountItemDto {
  BankAccountItemDto({
    required this.bankId,
    this.bankGuid,
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.iban,
    this.isPrimary,
    this.status,
    this.isActive,
  });

  factory BankAccountItemDto.fromJson(Map<String, dynamic> json) {
    return BankAccountItemDto(
      bankId: (json['bank_id'] as num?)?.toInt() ?? 0,
      bankGuid: json['bank_guid'] as String?,
      bankCode: json['bank_code'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      iban: json['iban'] as String?,
      isPrimary: json['is_primary'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int bankId;
  final String? bankGuid;
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? iban;
  final String? isPrimary;
  final String? status;
  final String? isActive;

  BankAccountItem toDomain() => BankAccountItem(
    bankId: bankId,
    bankGuid: bankGuid,
    bankCode: bankCode,
    bankName: bankName,
    accountNumber: accountNumber,
    iban: iban,
    isPrimary: isPrimary,
    status: status,
    isActive: isActive,
  );
}

class AddressItemDto {
  AddressItemDto({
    required this.addressId,
    this.addressGuid,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.area,
    this.countryCode,
    this.isPrimary,
    this.status,
    this.isActive,
  });

  factory AddressItemDto.fromJson(Map<String, dynamic> json) {
    return AddressItemDto(
      addressId: (json['address_id'] as num?)?.toInt() ?? 0,
      addressGuid: json['address_guid'] as String?,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
      countryCode: json['country_code'] as String?,
      isPrimary: json['is_primary'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int addressId;
  final String? addressGuid;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? area;
  final String? countryCode;
  final String? isPrimary;
  final String? status;
  final String? isActive;

  AddressItem toDomain() => AddressItem(
    addressId: addressId,
    addressGuid: addressGuid,
    addressLine1: addressLine1,
    addressLine2: addressLine2,
    city: city,
    area: area,
    countryCode: countryCode,
    isPrimary: isPrimary,
    status: status,
    isActive: isActive,
  );
}
