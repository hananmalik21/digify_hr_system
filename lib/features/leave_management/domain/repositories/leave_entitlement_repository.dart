import 'package:digify_hr_system/features/leave_management/domain/models/leave_entitlement.dart';

abstract class LeaveEntitlementRepository {
  Future<List<LeaveEntitlement>> getKuwaitLawEntitlements();
}
