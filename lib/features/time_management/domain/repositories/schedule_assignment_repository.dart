import 'package:digify_hr_system/features/time_management/domain/models/schedule_assignment.dart';

abstract class ScheduleAssignmentRepository {
  Future<PaginatedScheduleAssignments> getScheduleAssignments({required int tenantId, int page = 1, int pageSize = 10});
  Future<void> deleteScheduleAssignment({required int scheduleAssignmentId, required int tenantId, bool hard = true});
}
