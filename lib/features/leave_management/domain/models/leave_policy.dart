class LeavePolicy {
  final String? policyGuid;
  final String nameEn;
  final String nameAr;
  final bool isKuwaitLaw;
  final String description;
  final String entitlement;
  final String accrualType;
  final String minService;
  final String advanceNotice;
  final bool isPaid;
  final int? carryoverDays;
  final bool requiresAttachment;
  final String? genderRestriction;
  final int? entitlementDays;
  final String? accrualMethodCode;
  final String? status;
  final String? kuwaitLaborCompliant;

  const LeavePolicy({
    this.policyGuid,
    required this.nameEn,
    required this.nameAr,
    required this.isKuwaitLaw,
    required this.description,
    required this.entitlement,
    required this.accrualType,
    required this.minService,
    required this.advanceNotice,
    required this.isPaid,
    this.carryoverDays,
    required this.requiresAttachment,
    this.genderRestriction,
    this.entitlementDays,
    this.accrualMethodCode,
    this.status,
    this.kuwaitLaborCompliant,
  });

  LeavePolicy copyWith({
    String? policyGuid,
    String? nameEn,
    String? nameAr,
    bool? isKuwaitLaw,
    String? description,
    String? entitlement,
    String? accrualType,
    String? minService,
    String? advanceNotice,
    bool? isPaid,
    int? carryoverDays,
    bool? requiresAttachment,
    String? genderRestriction,
    int? entitlementDays,
    String? accrualMethodCode,
    String? status,
    String? kuwaitLaborCompliant,
  }) {
    return LeavePolicy(
      policyGuid: policyGuid ?? this.policyGuid,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      isKuwaitLaw: isKuwaitLaw ?? this.isKuwaitLaw,
      description: description ?? this.description,
      entitlement: entitlement ?? this.entitlement,
      accrualType: accrualType ?? this.accrualType,
      minService: minService ?? this.minService,
      advanceNotice: advanceNotice ?? this.advanceNotice,
      isPaid: isPaid ?? this.isPaid,
      carryoverDays: carryoverDays ?? this.carryoverDays,
      requiresAttachment: requiresAttachment ?? this.requiresAttachment,
      genderRestriction: genderRestriction ?? this.genderRestriction,
      entitlementDays: entitlementDays ?? this.entitlementDays,
      accrualMethodCode: accrualMethodCode ?? this.accrualMethodCode,
      status: status ?? this.status,
      kuwaitLaborCompliant: kuwaitLaborCompliant ?? this.kuwaitLaborCompliant,
    );
  }
}

class UpdateLeavePolicyParams {
  final String leaveTypeEn;
  final int entitlementDays;
  final String accrualMethodCode;
  final String status;
  final String kuwaitLaborCompliant;

  const UpdateLeavePolicyParams({
    required this.leaveTypeEn,
    required this.entitlementDays,
    required this.accrualMethodCode,
    required this.status,
    required this.kuwaitLaborCompliant,
  });
}

class CreateLeavePolicyParams {
  final int tenantId;
  final int leaveTypeId;
  final String leaveTypeEn;
  final String leaveTypeAr;
  final int entitlementDays;
  final String accrualMethodCode;
  final String status;
  final String kuwaitLaborCompliant;

  const CreateLeavePolicyParams({
    required this.tenantId,
    required this.leaveTypeId,
    required this.leaveTypeEn,
    required this.leaveTypeAr,
    required this.entitlementDays,
    required this.accrualMethodCode,
    required this.status,
    required this.kuwaitLaborCompliant,
  });
}
