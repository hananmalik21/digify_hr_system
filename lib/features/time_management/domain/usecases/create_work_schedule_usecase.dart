import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/work_schedule_repository.dart';

class CreateWorkScheduleUseCase {
  final WorkScheduleRepository repository;

  const CreateWorkScheduleUseCase({required this.repository});

  Future<WorkSchedule> call({required Map<String, dynamic> data}) async {
    return await repository.createWorkSchedule(data: data);
  }
}
