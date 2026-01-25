import 'package:digify_hr_system/features/leave_management/domain/models/leave_policy.dart';

abstract class LeavePoliciesRepository {
  Future<List<LeavePolicy>> getLeavePolicies({int? tenantId, String? status, String? kuwaitLaborCompliant});
}
