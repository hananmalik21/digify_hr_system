import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/all_leave_balances_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/forfeit_policy_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/forfeit_processing_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/forfeit_reports_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_balance_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_calendar_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_policies_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_request_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/policy_configuration_tab_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/team_leave_risk_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveRequestTabLookupsPreloadProvider = FutureProvider<void>((ref) async {
  final enterpriseId = ref.watch(leaveRequestTabEnterpriseIdProvider);
  if (enterpriseId == null) return;
  await ref.watch(absLookupValuesForEnterpriseProvider(enterpriseId).future);
});

final policyConfigurationTabLookupsPreloadProvider = FutureProvider<void>((ref) async {
  final enterpriseId = ref.watch(policyConfigurationTabEnterpriseIdProvider);
  if (enterpriseId == null) return;
  await ref.watch(absLookupValuesForEnterpriseProvider(enterpriseId).future);
});

List<AbsLookupValue> _lookupValuesForTab(Ref ref, int? enterpriseId, AbsLookupCode code) {
  if (enterpriseId == null) return [];
  return ref.watch(absLookupValuesForEnterpriseAndCodeProvider((enterpriseId: enterpriseId, code: code)));
}

final leaveRequestTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(leaveRequestTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final allLeaveBalancesTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((
  ref,
  code,
) {
  final enterpriseId = ref.watch(allLeaveBalancesTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final leaveBalanceTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(leaveBalanceTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final teamLeaveRiskTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(teamLeaveRiskTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final leavePoliciesTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(leavePoliciesTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final policyConfigurationTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((
  ref,
  code,
) {
  final enterpriseId = ref.watch(policyConfigurationTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final forfeitPolicyTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(forfeitPolicyTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final forfeitProcessingTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((
  ref,
  code,
) {
  final enterpriseId = ref.watch(forfeitProcessingTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final forfeitReportsTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(forfeitReportsTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});

final leaveCalendarTabLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, code) {
  final enterpriseId = ref.watch(leaveCalendarTabEnterpriseIdProvider);
  return _lookupValuesForTab(ref, enterpriseId, code);
});
