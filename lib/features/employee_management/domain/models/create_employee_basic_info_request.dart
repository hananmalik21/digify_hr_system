import 'package:digify_hr_system/core/utils/form_validators.dart';

class CreateEmployeeBasicInfoRequest {
  final String? firstNameEn;
  final String? lastNameEn;
  final String? middleNameEn;
  final String? firstNameAr;
  final String? lastNameAr;
  final String? middleNameAr;
  final String? email;
  final String? phoneNumber;
  final String? mobileNumber;
  final DateTime? dateOfBirth;
  final String? emergAddress;
  final String? emergPhone;
  final String? emergEmail;
  final String? emergRelationship;
  final String? contactName;
  final int? workScheduleId;
  final String? orgUnitIdHex;
  final Map<String, String?>? lookupCodesByTypeCode;
  final String? civilIdNumber;
  final String? passportNumber;
  final String? workLocation;
  final String? positionIdHex;
  final DateTime? enterpriseHireDate;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final int? probationDays;
  final String? contractTypeCode;
  final String? employmentStatusCode;
  final int? enterpriseId;

  const CreateEmployeeBasicInfoRequest({
    this.firstNameEn,
    this.lastNameEn,
    this.middleNameEn,
    this.firstNameAr,
    this.lastNameAr,
    this.middleNameAr,
    this.email,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    this.emergAddress,
    this.emergPhone,
    this.emergEmail,
    this.emergRelationship,
    this.contactName,
    this.workScheduleId,
    this.orgUnitIdHex,
    this.lookupCodesByTypeCode,
    this.civilIdNumber,
    this.passportNumber,
    this.workLocation,
    this.positionIdHex,
    this.enterpriseHireDate,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.probationDays,
    this.contractTypeCode,
    this.employmentStatusCode,
    this.enterpriseId,
  });

  CreateEmployeeBasicInfoRequest copyWith({
    String? firstNameEn,
    String? lastNameEn,
    String? middleNameEn,
    String? firstNameAr,
    String? lastNameAr,
    String? middleNameAr,
    String? email,
    String? phoneNumber,
    String? mobileNumber,
    DateTime? dateOfBirth,
    String? emergAddress,
    String? emergPhone,
    String? emergEmail,
    String? emergRelationship,
    String? contactName,
    int? workScheduleId,
    String? orgUnitIdHex,
    bool clearFirstNameEn = false,
    bool clearLastNameEn = false,
    bool clearMiddleNameEn = false,
    bool clearFirstNameAr = false,
    bool clearLastNameAr = false,
    bool clearMiddleNameAr = false,
    bool clearEmail = false,
    bool clearPhoneNumber = false,
    bool clearMobileNumber = false,
    bool clearDateOfBirth = false,
    bool clearEmergAddress = false,
    bool clearEmergPhone = false,
    bool clearEmergEmail = false,
    bool clearEmergRelationship = false,
    bool clearContactName = false,
    bool clearWorkScheduleId = false,
    bool clearOrgUnitIdHex = false,
    Map<String, String?>? lookupCodesByTypeCode,
    String? civilIdNumber,
    String? passportNumber,
    bool clearLookupCodesByTypeCode = false,
    bool clearCivilIdNumber = false,
    bool clearPassportNumber = false,
    String? workLocation,
    bool clearWorkLocation = false,
    String? positionIdHex,
    DateTime? enterpriseHireDate,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    int? probationDays,
    String? contractTypeCode,
    String? employmentStatusCode,
    bool clearPositionIdHex = false,
    bool clearEnterpriseHireDate = false,
    bool clearJobFamilyId = false,
    bool clearJobLevelId = false,
    bool clearGradeId = false,
    bool clearProbationDays = false,
    bool clearContractTypeCode = false,
    bool clearEmploymentStatusCode = false,
    int? enterpriseId,
    bool clearEnterpriseId = false,
  }) {
    return CreateEmployeeBasicInfoRequest(
      firstNameEn: clearFirstNameEn ? null : (firstNameEn ?? this.firstNameEn),
      lastNameEn: clearLastNameEn ? null : (lastNameEn ?? this.lastNameEn),
      middleNameEn: clearMiddleNameEn ? null : (middleNameEn ?? this.middleNameEn),
      firstNameAr: clearFirstNameAr ? null : (firstNameAr ?? this.firstNameAr),
      lastNameAr: clearLastNameAr ? null : (lastNameAr ?? this.lastNameAr),
      middleNameAr: clearMiddleNameAr ? null : (middleNameAr ?? this.middleNameAr),
      email: clearEmail ? null : (email ?? this.email),
      phoneNumber: clearPhoneNumber ? null : (phoneNumber ?? this.phoneNumber),
      mobileNumber: clearMobileNumber ? null : (mobileNumber ?? this.mobileNumber),
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      emergAddress: clearEmergAddress ? null : (emergAddress ?? this.emergAddress),
      emergPhone: clearEmergPhone ? null : (emergPhone ?? this.emergPhone),
      emergEmail: clearEmergEmail ? null : (emergEmail ?? this.emergEmail),
      emergRelationship: clearEmergRelationship ? null : (emergRelationship ?? this.emergRelationship),
      contactName: clearContactName ? null : (contactName ?? this.contactName),
      workScheduleId: clearWorkScheduleId ? null : (workScheduleId ?? this.workScheduleId),
      orgUnitIdHex: clearOrgUnitIdHex ? null : (orgUnitIdHex ?? this.orgUnitIdHex),
      lookupCodesByTypeCode: clearLookupCodesByTypeCode ? null : (lookupCodesByTypeCode ?? this.lookupCodesByTypeCode),
      civilIdNumber: clearCivilIdNumber ? null : (civilIdNumber ?? this.civilIdNumber),
      passportNumber: clearPassportNumber ? null : (passportNumber ?? this.passportNumber),
      workLocation: clearWorkLocation ? null : (workLocation ?? this.workLocation),
      positionIdHex: clearPositionIdHex ? null : (positionIdHex ?? this.positionIdHex),
      enterpriseHireDate: clearEnterpriseHireDate ? null : (enterpriseHireDate ?? this.enterpriseHireDate),
      jobFamilyId: clearJobFamilyId ? null : (jobFamilyId ?? this.jobFamilyId),
      jobLevelId: clearJobLevelId ? null : (jobLevelId ?? this.jobLevelId),
      gradeId: clearGradeId ? null : (gradeId ?? this.gradeId),
      probationDays: clearProbationDays ? null : (probationDays ?? this.probationDays),
      contractTypeCode: clearContractTypeCode ? null : (contractTypeCode ?? this.contractTypeCode),
      employmentStatusCode: clearEmploymentStatusCode ? null : (employmentStatusCode ?? this.employmentStatusCode),
      enterpriseId: clearEnterpriseId ? null : (enterpriseId ?? this.enterpriseId),
    );
  }

  static String typeCodeToApiKey(String typeCode) => '${typeCode.toLowerCase()}_code';

  static String formatDateOfBirth(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  bool get isEmailValid => FormValidators.email(email) == null;

  bool get isPhoneValid => FormValidators.phone(phoneNumber) == null;

  bool get isStep1Valid =>
      (firstNameEn?.trim().isNotEmpty ?? false) &&
      (lastNameEn?.trim().isNotEmpty ?? false) &&
      (firstNameAr?.trim().isNotEmpty ?? false) &&
      (lastNameAr?.trim().isNotEmpty ?? false) &&
      isEmailValid &&
      isPhoneValid &&
      dateOfBirth != null;
}
