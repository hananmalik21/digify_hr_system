class LeavePolicy {
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

  const LeavePolicy({
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
  });
}
