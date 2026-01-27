import 'package:digify_hr_system/features/leave_management/domain/models/forfeit_schedule_entry.dart';

abstract class ForfeitScheduleRepository {
  Future<List<ForfeitScheduleEntry>> getForfeitScheduleEntries();
}
