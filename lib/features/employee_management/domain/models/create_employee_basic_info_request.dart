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
    );
  }

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
