import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';

abstract class LeaveBalancesRepository {
  Future<PaginatedLeaveBalances> getLeaveBalances({int page = 1, int pageSize = 10, int? tenantId});

  Future<void> updateLeaveBalance(String employeeLeaveBalanceGuid, UpdateLeaveBalanceParams params, {int? tenantId});
}
