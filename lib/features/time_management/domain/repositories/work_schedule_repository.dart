import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';

abstract class WorkScheduleRepository {
  Future<PaginatedWorkSchedules> getWorkSchedules({int page = 1, int pageSize = 10});
}
