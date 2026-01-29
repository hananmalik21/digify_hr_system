import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_list_enums.dart';
import 'package:intl/intl.dart';

/// Full policy detail from GET /api/abs/policies response.
/// Contains all data needed to populate the policy configuration UI.
class PolicyDetail {
  // Basic Info
  final int policyId;
  final String policyGuid;
  final int tenantId;
  final int leaveTypeId;
  final String leaveTypeEn;
  final String leaveTypeAr;
  final String? policyName;
  final int entitlementDays;
  final PolicyAccrualMethod accrualMethod;
  final PolicyStatus status;
  final bool kuwaitLaborCompliant;
  final String? createdBy;
  final DateTime? createdDate;

  // Eligibility
  final int? minServiceYears;
  final int? maxServiceYears;
  final String? employeeCategoryCode;
  final String? employmentTypeCode;
  final String? contractTypeCode;
  final String? genderCode;
  final String? religionCode;
  final String? maritalStatusCode;
  final bool probationAllowed;

  // Advanced Rules
  final int? minNoticeDays;
  final int? maxConsecutiveDays;
  final bool requiresDocument;

  // Carry Forward
  final bool allowCarryForward;
  final int? carryForwardLimitDays;
  final int? gracePeriodDays;

  // Forfeit
  final bool autoForfeit;
  final String? forfeitTriggerCode;
  final int? notifyBeforeDays;

  // Encashment
  final bool allowEncashment;
  final int? encashmentLimitDays;
  final int? encashmentRatePct;

  // Grade Entitlements
  final List<GradeEntitlement> gradeRows;

  const PolicyDetail({
    required this.policyId,
    required this.policyGuid,
    required this.tenantId,
    required this.leaveTypeId,
    required this.leaveTypeEn,
    required this.leaveTypeAr,
    this.policyName,
    required this.entitlementDays,
    required this.accrualMethod,
    required this.status,
    required this.kuwaitLaborCompliant,
    this.createdBy,
    this.createdDate,
    this.minServiceYears,
    this.maxServiceYears,
    this.employeeCategoryCode,
    this.employmentTypeCode,
    this.contractTypeCode,
    this.genderCode,
    this.religionCode,
    this.maritalStatusCode,
    required this.probationAllowed,
    this.minNoticeDays,
    this.maxConsecutiveDays,
    required this.requiresDocument,
    required this.allowCarryForward,
    this.carryForwardLimitDays,
    this.gracePeriodDays,
    required this.autoForfeit,
    this.forfeitTriggerCode,
    this.notifyBeforeDays,
    required this.allowEncashment,
    this.encashmentLimitDays,
    this.encashmentRatePct,
    this.gradeRows = const [],
  });

  PolicyDetail copyWith({
    int? policyId,
    String? policyGuid,
    int? tenantId,
    int? leaveTypeId,
    String? leaveTypeEn,
    String? leaveTypeAr,
    String? policyName,
    int? entitlementDays,
    PolicyAccrualMethod? accrualMethod,
    PolicyStatus? status,
    bool? kuwaitLaborCompliant,
    String? createdBy,
    DateTime? createdDate,
    int? minServiceYears,
    int? maxServiceYears,
    String? employeeCategoryCode,
    String? employmentTypeCode,
    String? contractTypeCode,
    String? genderCode,
    String? religionCode,
    String? maritalStatusCode,
    bool? probationAllowed,
    int? minNoticeDays,
    int? maxConsecutiveDays,
    bool? requiresDocument,
    bool? allowCarryForward,
    int? carryForwardLimitDays,
    int? gracePeriodDays,
    bool? autoForfeit,
    String? forfeitTriggerCode,
    int? notifyBeforeDays,
    bool? allowEncashment,
    int? encashmentLimitDays,
    int? encashmentRatePct,
    List<GradeEntitlement>? gradeRows,
  }) {
    return PolicyDetail(
      policyId: policyId ?? this.policyId,
      policyGuid: policyGuid ?? this.policyGuid,
      tenantId: tenantId ?? this.tenantId,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      leaveTypeEn: leaveTypeEn ?? this.leaveTypeEn,
      leaveTypeAr: leaveTypeAr ?? this.leaveTypeAr,
      policyName: policyName ?? this.policyName,
      entitlementDays: entitlementDays ?? this.entitlementDays,
      accrualMethod: accrualMethod ?? this.accrualMethod,
      status: status ?? this.status,
      kuwaitLaborCompliant: kuwaitLaborCompliant ?? this.kuwaitLaborCompliant,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      minServiceYears: minServiceYears ?? this.minServiceYears,
      maxServiceYears: maxServiceYears ?? this.maxServiceYears,
      employeeCategoryCode: employeeCategoryCode ?? this.employeeCategoryCode,
      employmentTypeCode: employmentTypeCode ?? this.employmentTypeCode,
      contractTypeCode: contractTypeCode ?? this.contractTypeCode,
      genderCode: genderCode ?? this.genderCode,
      religionCode: religionCode ?? this.religionCode,
      maritalStatusCode: maritalStatusCode ?? this.maritalStatusCode,
      probationAllowed: probationAllowed ?? this.probationAllowed,
      minNoticeDays: minNoticeDays ?? this.minNoticeDays,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
      requiresDocument: requiresDocument ?? this.requiresDocument,
      allowCarryForward: allowCarryForward ?? this.allowCarryForward,
      carryForwardLimitDays: carryForwardLimitDays ?? this.carryForwardLimitDays,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      autoForfeit: autoForfeit ?? this.autoForfeit,
      forfeitTriggerCode: forfeitTriggerCode ?? this.forfeitTriggerCode,
      notifyBeforeDays: notifyBeforeDays ?? this.notifyBeforeDays,
      allowEncashment: allowEncashment ?? this.allowEncashment,
      encashmentLimitDays: encashmentLimitDays ?? this.encashmentLimitDays,
      encashmentRatePct: encashmentRatePct ?? this.encashmentRatePct,
      gradeRows: gradeRows ?? this.gradeRows,
    );
  }

  /// Display name for the policy (uses leave type name)
  String get displayName => leaveTypeEn;

  /// Formatted created date
  String get formattedCreatedDate {
    if (createdDate == null) return '-';
    return DateFormat('yyyy-MM-dd').format(createdDate!);
  }

  /// Build grade restriction string from grade rows
  String? get gradesRestriction {
    if (gradeRows.isEmpty) return null;
    return gradeRows
        .map((g) {
          final from = g.gradeFrom ?? 1;
          final to = g.gradeTo != null ? '${g.gradeTo}' : '+';
          return 'Grade $from-$to: ${g.entitlementDays} days';
        })
        .join(', ');
  }

  /// Convert to PolicyConfiguration for UI display
  PolicyConfiguration toConfiguration() {
    return PolicyConfiguration(
      policyName: leaveTypeEn,
      policyNameArabic: leaveTypeAr,
      version: '1.0',
      lastModified: formattedCreatedDate,
      selectedBy: createdBy ?? 'System',
      tags: ['$entitlementDays Days', accrualMethod.displayName],
      isActive: status == PolicyStatus.active,
      eligibilityCriteria: EligibilityCriteria(
        yearsOfServiceEnabled: minServiceYears != null,
        minYearsRequired: minServiceYears?.toString(),
        maxYearsAllowed: maxServiceYears?.toString() ?? 'No limit',
        employeeCategoryEnabled: employeeCategoryCode != null,
        employeeCategory: _formatCode(employeeCategoryCode),
        employeeCategoryCode: employeeCategoryCode,
        employmentTypeEnabled: employmentTypeCode != null,
        employmentType: _formatCode(employmentTypeCode),
        employmentTypeCode: employmentTypeCode,
        contractTypeEnabled: contractTypeCode != null,
        contractType: _formatCode(contractTypeCode),
        contractTypeCode: contractTypeCode,
        genderEnabled: genderCode != null,
        gender: _formatCode(genderCode),
        genderCode: genderCode,
        religionEnabled: religionCode != null,
        religion: _formatCode(religionCode),
        religionCode: religionCode,
        maritalStatusEnabled: maritalStatusCode != null,
        maritalStatus: _formatCode(maritalStatusCode),
        maritalStatusCode: maritalStatusCode,
        availableDuringProbation: probationAllowed,
        gradesRestriction: gradesRestriction,
      ),
      entitlementAccrual: EntitlementAccrual(
        annualEntitlement: entitlementDays.toString(),
        accrualMethod: accrualMethod.displayName,
        accrualRate: _calculateAccrualRate(),
        effectiveDate: formattedCreatedDate,
        enableProRataCalculation: false,
      ),
      advancedRules: AdvancedRules(
        maxConsecutiveDays: maxConsecutiveDays?.toString() ?? '-',
        minNoticePeriod: minNoticeDays?.toString() ?? '-',
        countWeekendsAsLeave: false,
        countPublicHolidaysAsLeave: false,
        requiredSupportingDocumentation: requiresDocument,
      ),
      approvalWorkflows: const ApprovalWorkflows(approvalWorkflow: 'Manager', autoApprovalThreshold: '0'),
      blackoutPeriods: const BlackoutPeriods(fromTo: '-'),
      carryForwardRules: CarryForwardRules(
        allowCarryForward: allowCarryForward,
        carryForwardLimit: carryForwardLimitDays?.toString() ?? '0',
        gracePeriod: gracePeriodDays?.toString() ?? '0',
      ),
      forfeitRules: ForfeitRules(
        enableAutomaticForfeit: autoForfeit,
        forfeitTrigger: _formatForfeitTrigger(forfeitTriggerCode),
        endOfGracePeriod: notifyBeforeDays != null ? '$notifyBeforeDays days before' : '-',
      ),
      encashmentRules: EncashmentRules(
        allowLeaveEncashment: allowEncashment,
        encashmentLimit: encashmentLimitDays?.toString() ?? '0',
        encashmentRate: encashmentRatePct?.toString() ?? '0',
      ),
      complianceCheck: ComplianceCheck(
        minimumEntitlementMet: kuwaitLaborCompliant,
        accrualMethodValid: true,
        eligibilityCriteriaValid: true,
      ),
    );
  }

  /// Calculate accrual rate based on method
  String _calculateAccrualRate() {
    switch (accrualMethod) {
      case PolicyAccrualMethod.monthly:
        return (entitlementDays / 12).toStringAsFixed(2);
      case PolicyAccrualMethod.yearly:
        return entitlementDays.toString();
      case PolicyAccrualMethod.none:
        return '0';
    }
  }

  /// Format code to display name (e.g., FIXED_TERM -> Fixed Term)
  String? _formatCode(String? code) {
    if (code == null || code.isEmpty) return null;
    return code
        .split('_')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
        .join(' ');
  }

  /// Format forfeit trigger code to display name
  String? _formatForfeitTrigger(String? code) {
    if (code == null || code.isEmpty) return null;
    switch (code.toUpperCase()) {
      case 'END_OF_GRACE':
        return 'End of Grace Period';
      case 'END_OF_YEAR':
        return 'End of Year';
      default:
        return _formatCode(code);
    }
  }
}

/// Grade-based entitlement row
class GradeEntitlement {
  final int entitlementId;
  final int? gradeFrom;
  final int? gradeTo;
  final int entitlementDays;
  final double? accrualRate;
  final bool isActive;

  const GradeEntitlement({
    required this.entitlementId,
    this.gradeFrom,
    this.gradeTo,
    required this.entitlementDays,
    this.accrualRate,
    required this.isActive,
  });

  String get gradeRange {
    final from = gradeFrom ?? 1;
    final to = gradeTo != null ? '$gradeTo' : '+';
    return '$from - $to';
  }
}
