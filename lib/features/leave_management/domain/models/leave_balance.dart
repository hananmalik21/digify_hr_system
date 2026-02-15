import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';

/// Domain model for a single leave balance record from the API.
class LeaveBalance {
  final String employeeLeaveBalanceGuid;
  final int tenantId;
  final int employeeId;
  final String employeeGuid;
  final String employeeName;
  final int leaveTypeId;
  final double openingBalanceDays;
  final double accruedDays;
  final double takenDays;
  final double adjustedDays;
  final double availableDays;
  final DateTime? lastAccrualDate;
  final DateTime? periodStartDate;
  final DateTime? periodEndDate;
  final String status;
  final DateTime? creationDate;
  final String? createdBy;
  final DateTime? lastUpdateDate;
  final String? lastUpdatedBy;

  const LeaveBalance({
    required this.employeeLeaveBalanceGuid,
    required this.tenantId,
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeName,
    required this.leaveTypeId,
    required this.openingBalanceDays,
    required this.accruedDays,
    required this.takenDays,
    required this.adjustedDays,
    required this.availableDays,
    this.lastAccrualDate,
    this.periodStartDate,
    this.periodEndDate,
    required this.status,
    this.creationDate,
    this.createdBy,
    this.lastUpdateDate,
    this.lastUpdatedBy,
  });

  LeaveBalance copyWith({
    String? employeeLeaveBalanceGuid,
    int? tenantId,
    int? employeeId,
    String? employeeGuid,
    String? employeeName,
    int? leaveTypeId,
    double? openingBalanceDays,
    double? accruedDays,
    double? takenDays,
    double? adjustedDays,
    double? availableDays,
    DateTime? lastAccrualDate,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    String? status,
    DateTime? creationDate,
    String? createdBy,
    DateTime? lastUpdateDate,
    String? lastUpdatedBy,
  }) {
    return LeaveBalance(
      employeeLeaveBalanceGuid: employeeLeaveBalanceGuid ?? this.employeeLeaveBalanceGuid,
      tenantId: tenantId ?? this.tenantId,
      employeeId: employeeId ?? this.employeeId,
      employeeGuid: employeeGuid ?? this.employeeGuid,
      employeeName: employeeName ?? this.employeeName,
      leaveTypeId: leaveTypeId ?? this.leaveTypeId,
      openingBalanceDays: openingBalanceDays ?? this.openingBalanceDays,
      accruedDays: accruedDays ?? this.accruedDays,
      takenDays: takenDays ?? this.takenDays,
      adjustedDays: adjustedDays ?? this.adjustedDays,
      availableDays: availableDays ?? this.availableDays,
      lastAccrualDate: lastAccrualDate ?? this.lastAccrualDate,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      status: status ?? this.status,
      creationDate: creationDate ?? this.creationDate,
      createdBy: createdBy ?? this.createdBy,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }
}

class AdjustLeaveBalanceResult {
  final String employeeLeaveBalanceGuid;
  final double openingBalanceDays;
  final double accruedDays;
  final double takenDays;
  final double adjustedDays;
  final double availableDays;
  final String status;
  final String comments;

  const AdjustLeaveBalanceResult({
    required this.employeeLeaveBalanceGuid,
    required this.openingBalanceDays,
    required this.accruedDays,
    required this.takenDays,
    required this.adjustedDays,
    required this.availableDays,
    required this.status,
    required this.comments,
  });

  UpdateLeaveBalanceParams toUpdateParams() => UpdateLeaveBalanceParams(
    openingBalanceDays: openingBalanceDays,
    accruedDays: accruedDays,
    takenDays: takenDays,
    adjustedDays: adjustedDays,
    availableDays: availableDays,
    status: status,
    comments: comments,
  );
}

/// Params for updating a leave balance via PUT.
class UpdateLeaveBalanceParams {
  final double openingBalanceDays;
  final double accruedDays;
  final double takenDays;
  final double adjustedDays;
  final double availableDays;
  final String status;
  final String comments;

  const UpdateLeaveBalanceParams({
    required this.openingBalanceDays,
    required this.accruedDays,
    required this.takenDays,
    required this.adjustedDays,
    required this.availableDays,
    required this.status,
    required this.comments,
  });
}

/// Paginated leave balances result.
class PaginatedLeaveBalances {
  final List<LeaveBalance> balances;
  final PaginationInfo pagination;

  const PaginatedLeaveBalances({required this.balances, required this.pagination});
}
