import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_balances_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_balances_repository.dart';

class LeaveBalancesRepositoryImpl implements LeaveBalancesRepository {
  final LeaveBalancesRemoteDataSource remoteDataSource;

  LeaveBalancesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedLeaveBalances> getLeaveBalances({int page = 1, int pageSize = 10, int? tenantId}) async {
    try {
      final dto = await remoteDataSource.getLeaveBalances(page: page, pageSize: pageSize, tenantId: tenantId);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave balances: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateLeaveBalance(
    String employeeLeaveBalanceGuid,
    UpdateLeaveBalanceParams params, {
    int? tenantId,
  }) async {
    try {
      final body = <String, dynamic>{
        'opening_balance_days': params.openingBalanceDays,
        'accrued_days': params.accruedDays,
        'taken_days': params.takenDays,
        'adjusted_days': params.adjustedDays,
        'available_days': params.availableDays,
        'status': params.status,
        'comments': params.comments,
      };
      await remoteDataSource.updateLeaveBalance(employeeLeaveBalanceGuid, body, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to update leave balance: ${e.toString()}', originalError: e);
    }
  }
}
