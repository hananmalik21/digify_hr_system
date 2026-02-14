import 'package:digify_hr_system/features/timesheet/domain/models/timesheet.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet_status.dart';

/// Repository interface for timesheet operations
abstract class TimesheetRepository {
  /// Gets paginated list of timesheets
  Future<List<Timesheet>> getTimesheets({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? searchQuery,
    TimesheetStatus? status,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets timesheet statistics
  Future<Map<String, dynamic>> getTimesheetStatistics({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  });

  /// Gets timesheet by ID
  Future<Timesheet> getTimesheetById(int timesheetId);

  /// Creates a new timesheet
  Future<Timesheet> createTimesheet(Map<String, dynamic> timesheetData);

  /// Updates an existing timesheet
  Future<Timesheet> updateTimesheet(int timesheetId, Map<String, dynamic> timesheetData);

  /// Submits a timesheet for approval
  Future<Timesheet> submitTimesheet(int timesheetId);

  /// Approves a timesheet
  Future<Timesheet> approveTimesheet(int timesheetId, {String? notes});

  /// Rejects a timesheet
  Future<Timesheet> rejectTimesheet(int timesheetId, {required String reason});

  /// Deletes a timesheet
  Future<void> deleteTimesheet(int timesheetId);
}

