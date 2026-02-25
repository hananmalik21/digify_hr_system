import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet_page.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/timesheet/timesheet_status.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/repositories/timesheet_repository.dart';

class GetTimesheetsUseCase {
  final TimesheetRepository repository;

  const GetTimesheetsUseCase({required this.repository});

  Future<TimesheetPage> call({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? searchQuery,
    TimesheetStatus? status,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      return await repository.getTimesheets(
        weekStartDate: weekStartDate,
        weekEndDate: weekEndDate,
        employeeNumber: employeeNumber,
        searchQuery: searchQuery,
        status: status,
        companyId: companyId,
        divisionId: divisionId,
        departmentId: departmentId,
        sectionId: sectionId,
        orgUnitId: orgUnitId,
        levelCode: levelCode,
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get timesheets: ${e.toString()}', originalError: e);
    }
  }
}
