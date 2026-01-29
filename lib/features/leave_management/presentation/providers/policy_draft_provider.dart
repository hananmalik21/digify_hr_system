import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_detail.dart';

class PolicyDraftNotifier extends StateNotifier<PolicyDetail?> {
  PolicyDraftNotifier() : super(null);

  void setDraft(PolicyDetail detail) {
    state = detail;
  }

  void clear() {
    state = null;
  }

  void updateEmployeeCategoryCode(String? code) {
    state = state?.copyWith(employeeCategoryCode: code);
  }

  void updateEmploymentTypeCode(String? code) {
    state = state?.copyWith(employmentTypeCode: code);
  }

  void updateContractTypeCode(String? code) {
    state = state?.copyWith(contractTypeCode: code);
  }

  void updateGenderCode(String? code) {
    state = state?.copyWith(genderCode: code);
  }

  void updateReligionCode(String? code) {
    state = state?.copyWith(religionCode: code);
  }

  void updateMaritalStatusCode(String? code) {
    state = state?.copyWith(maritalStatusCode: code);
  }

  void updateProbationAllowed(bool value) {
    state = state?.copyWith(probationAllowed: value);
  }

  void updateMinServiceYears(int? value) {
    state = state?.copyWith(minServiceYears: value);
  }

  void updateMaxServiceYears(int? value) {
    state = state?.copyWith(maxServiceYears: value);
  }

  void updateGradeRowAt(int index, GradeEntitlement grade) {
    final List<GradeEntitlement> list = state?.gradeRows.toList() ?? <GradeEntitlement>[];
    if (index < 0 || index >= list.length) return;
    list[index] = grade;
    state = state?.copyWith(gradeRows: list);
  }

  void addGradeRow() {
    const newRow = GradeEntitlement(
      entitlementId: 0,
      gradeFrom: 1,
      gradeTo: null,
      entitlementDays: 0,
      accrualRate: null,
      isActive: true,
    );
    final List<GradeEntitlement> list = [...(state?.gradeRows ?? <GradeEntitlement>[]), newRow];
    state = state?.copyWith(gradeRows: list);
  }

  void removeGradeRowAt(int index) {
    final List<GradeEntitlement> list = state?.gradeRows.toList() ?? <GradeEntitlement>[];
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    state = state?.copyWith(gradeRows: list);
  }

  void updateEnableProRata(bool value) {
    state = state?.copyWith(enableProRata: value);
  }

  void updateMinNoticeDays(int? value) {
    state = state?.copyWith(minNoticeDays: value);
  }

  void updateMaxConsecutiveDays(int? value) {
    state = state?.copyWith(maxConsecutiveDays: value);
  }

  void updateRequiresDocument(bool value) {
    state = state?.copyWith(requiresDocument: value);
  }

  void updateCountWeekendsAsLeave(bool value) {
    state = state?.copyWith(countWeekendsAsLeave: value);
  }

  void updateCountPublicHolidaysAsLeave(bool value) {
    state = state?.copyWith(countPublicHolidaysAsLeave: value);
  }

  void updateAllowCarryForward(bool value) {
    state = state?.copyWith(allowCarryForward: value);
  }

  void updateCarryForwardLimitDays(int? value) {
    state = state?.copyWith(carryForwardLimitDays: value);
  }

  void updateGracePeriodDays(int? value) {
    state = state?.copyWith(gracePeriodDays: value);
  }

  void updateAutoForfeit(bool value) {
    state = state?.copyWith(autoForfeit: value);
  }

  void updateAllowEncashment(bool value) {
    state = state?.copyWith(allowEncashment: value);
  }

  void updateEncashmentLimitDays(int? value) {
    state = state?.copyWith(encashmentLimitDays: value);
  }

  void updateEncashmentRatePct(int? value) {
    state = state?.copyWith(encashmentRatePct: value);
  }
}

final policyDraftProvider = StateNotifierProvider<PolicyDraftNotifier, PolicyDetail?>((ref) {
  return PolicyDraftNotifier();
});
