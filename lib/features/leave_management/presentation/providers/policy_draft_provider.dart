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
}

final policyDraftProvider = StateNotifierProvider<PolicyDraftNotifier, PolicyDetail?>((ref) {
  return PolicyDraftNotifier();
});
