import 'package:digify_hr_system/features/timesheet/domain/models/timesheet.dart';
import 'package:digify_hr_system/features/timesheet/domain/models/timesheet_status.dart';
import 'package:digify_hr_system/features/timesheet/domain/repositories/timesheet_repository.dart';

/// Mock implementation of TimesheetRepository
class TimesheetRepositoryImpl implements TimesheetRepository {
  @override
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
  }) async {
    // Mock data - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    final mockTimesheets = [
      Timesheet(
        id: 1,
        employeeId: 1,
        employeeName: 'Ahmed Al-Mutairi',
        employeeNumber: 'EMP-001',
        departmentName: 'IT',
        weekStartDate: DateTime(2024, 12, 9),
        weekEndDate: DateTime(2024, 12, 15),
        regularHours: 40.0,
        overtimeHours: 2.0,
        totalHours: 42.0,
        status: TimesheetStatus.approved,
        createdAt: DateTime(2024, 12, 8),
        approvedAt: DateTime(2024, 12, 16),
      ),
      Timesheet(
        id: 2,
        employeeId: 2,
        employeeName: 'Fatima Al-Sabah',
        employeeNumber: 'EMP-002',
        departmentName: 'HR',
        weekStartDate: DateTime(2024, 12, 9),
        weekEndDate: DateTime(2024, 12, 15),
        regularHours: 40.0,
        overtimeHours: 0.0,
        totalHours: 40.0,
        status: TimesheetStatus.submitted,
        createdAt: DateTime(2024, 12, 8),
        submittedAt: DateTime(2024, 12, 15),
      ),
    ];

    // Apply filters
    var filtered = mockTimesheets;

    if (employeeNumber != null && employeeNumber.isNotEmpty) {
      filtered = filtered.where((t) => t.employeeNumber.contains(employeeNumber)).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (t) =>
                t.employeeName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                t.employeeNumber.toLowerCase().contains(searchQuery.toLowerCase()) ||
                t.departmentName.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (status != null) {
      filtered = filtered.where((t) => t.status == status).toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    if (startIndex >= filtered.length) {
      return [];
    }
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  @override
  Future<Map<String, dynamic>> getTimesheetStatistics({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  }) async {
    // Mock statistics - replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));

    return {
      'total': 2,
      'draft': 0,
      'submitted': 1,
      'approved': 1,
      'rejected': 0,
      'regularHours': 80.0,
      'overtimeHours': 2.0,
    };
  }

  @override
  Future<Timesheet> getTimesheetById(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation
    return Timesheet(
      id: timesheetId,
      employeeId: 1,
      employeeName: 'Ahmed Al-Mutairi',
      employeeNumber: 'EMP-001',
      departmentName: 'IT',
      weekStartDate: DateTime(2024, 12, 9),
      weekEndDate: DateTime(2024, 12, 15),
      regularHours: 40.0,
      overtimeHours: 2.0,
      totalHours: 42.0,
      status: TimesheetStatus.approved,
    );
  }

  @override
  Future<Timesheet> createTimesheet(Map<String, dynamic> timesheetData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('createTimesheet not implemented');
  }

  @override
  Future<Timesheet> updateTimesheet(int timesheetId, Map<String, dynamic> timesheetData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('updateTimesheet not implemented');
  }

  @override
  Future<Timesheet> submitTimesheet(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('submitTimesheet not implemented');
  }

  @override
  Future<Timesheet> approveTimesheet(int timesheetId, {String? notes}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('approveTimesheet not implemented');
  }

  @override
  Future<Timesheet> rejectTimesheet(int timesheetId, {required String reason}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('rejectTimesheet not implemented');
  }

  @override
  Future<void> deleteTimesheet(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('deleteTimesheet not implemented');
  }
}
