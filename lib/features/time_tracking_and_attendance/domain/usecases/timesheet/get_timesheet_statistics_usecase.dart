import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/repositories/timesheet_repository.dart';

class GetTimesheetStatisticsUseCase {
  final TimesheetRepository repository;

  const GetTimesheetStatisticsUseCase({required this.repository});

  Future<Map<String, dynamic>> call({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  }) async {
    try {
      return await repository.getTimesheetStatistics(
        weekStartDate: weekStartDate,
        weekEndDate: weekEndDate,
        employeeNumber: employeeNumber,
        companyId: companyId,
        divisionId: divisionId,
        departmentId: departmentId,
        sectionId: sectionId,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get timesheet statistics: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
