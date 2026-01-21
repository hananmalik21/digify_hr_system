import 'package:digify_hr_system/features/leave_management/domain/models/leave_type.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/policy_configuration.dart';

abstract class PolicyConfigurationRepository {
  Future<List<LeaveType>> getLeaveTypes();
  Future<PolicyConfiguration?> getPolicyConfiguration(String policyName);
  Future<List<PolicyConfiguration>> getAllPolicyConfigurations();
}
