import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_level_repository.dart';

class UpdateJobLevelUseCase {
  final JobLevelRepository repository;

  UpdateJobLevelUseCase(this.repository);

  Future<JobLevel> execute(JobLevel jobLevel) {
    return repository.updateJobLevel(jobLevel);
  }
}
