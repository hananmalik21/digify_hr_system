import 'package:digify_hr_system/features/time_management/domain/models/schedule_assignment.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/schedule_assignment_repository.dart';

class CreateScheduleAssignmentUseCase {
  final ScheduleAssignmentRepository repository;

  const CreateScheduleAssignmentUseCase({required this.repository});

  Future<ScheduleAssignment> call({required int tenantId, required Map<String, dynamic> assignmentData}) async {
    return await repository.createScheduleAssignment(tenantId: tenantId, assignmentData: assignmentData);
  }
}
