import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/domain/models/timesheet.dart';

/// Repository interface for timesheet operations
abstract class TimesheetRepository {
  /// Gets paginated list of timesheets
  ///
  /// [employeeId] - Optional filter by employee ID
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [status] - Optional filter by status
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedTimesheets> getTimesheets({
    int? employeeId,
    DateTime? startDate,
    DateTime? endDate,
    TimesheetStatus? status,
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets timesheet by ID
  ///
  /// Throws [AppException] if the operation fails
  Future<Timesheet> getTimesheetById(int timesheetId);

  /// Creates a new timesheet
  ///
  /// Throws [AppException] if the operation fails
  Future<Timesheet> createTimesheet(Map<String, dynamic> timesheetData);

  /// Updates an existing timesheet
  ///
  /// Throws [AppException] if the operation fails
  Future<Timesheet> updateTimesheet(
    int timesheetId,
    Map<String, dynamic> timesheetData,
  );

  /// Submits a timesheet for approval
  ///
  /// Throws [AppException] if the operation fails
  Future<Timesheet> submitTimesheet(int timesheetId);

  /// Approves a timesheet
  ///
  /// Throws [AppException] if the operation fails
  Future<Timesheet> approveTimesheet(int timesheetId, {String? notes});

  /// Rejects a timesheet
  ///
  /// Throws [AppException] if the operation fails
  Future<Timesheet> rejectTimesheet(int timesheetId, {required String reason});

  /// Deletes a timesheet
  ///
  /// [hard] - If true, permanently deletes. If false, soft deletes.
  /// Throws [AppException] if the operation fails
  Future<void> deleteTimesheet(int timesheetId, {bool hard = true});
}
