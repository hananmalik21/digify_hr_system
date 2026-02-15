import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/leave_management/data/datasources/leave_balances_remote_data_source.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/leave_balances_repository.dart';

class LeaveBalancesRepositoryImpl implements LeaveBalancesRepository {
  final LeaveBalancesRemoteDataSource remoteDataSource;

  LeaveBalancesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedLeaveBalances> getLeaveBalances({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? employeeGuid,
  }) async {
    try {
      final dto = await remoteDataSource.getLeaveBalances(
        page: page,
        pageSize: pageSize,
        tenantId: tenantId,
        employeeGuid: employeeGuid,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave balances: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<LeaveBalance>> getLeaveBalancesForEmployee(String employeeGuid, {int? tenantId}) async {
    try {
      final paginated = await remoteDataSource.getLeaveBalances(
        page: 1,
        pageSize: 50,
        tenantId: tenantId,
        employeeGuid: employeeGuid,
      );
      final list = paginated.toDomain().balances;
      return list.where((b) => b.employeeGuid == employeeGuid).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: Failed to fetch leave balances for employee: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<PaginatedLeaveBalanceSummaries> getLeaveBalanceSummaries({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? search,
  }) async {
    try {
      final dto = await remoteDataSource.getLeaveBalanceSummaries(
        page: page,
        pageSize: pageSize,
        tenantId: tenantId,
        search: search,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: Failed to fetch leave balance summaries: ${e.toString()}',
        originalError: e,
      );
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

  @override
  Future<void> adjustLeaveBalances({
    required int tenantId,
    required int employeeId,
    required String reason,
    required double annualDays,
    required double sickDays,
  }) async {
    try {
      final body = <String, dynamic>{
        'tenant_id': tenantId,
        'employee_id': employeeId,
        'reason': reason,
        'source': 'MANUAL',
        'leave_items': <Map<String, dynamic>>[
          {'leave_code': 'ANNUAL_LEAVE', 'new_days': annualDays},
          {'leave_code': 'SICK_LEAVE', 'new_days': sickDays},
        ],
      };
      await remoteDataSource.adjustLeaveBalances(body, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to adjust leave balances: ${e.toString()}', originalError: e);
    }
  }
}
