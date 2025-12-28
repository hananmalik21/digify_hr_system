import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_level_repository.dart';

class GetJobLevelsUseCase {
  final JobLevelRepository repository;

  GetJobLevelsUseCase(this.repository);

  Future<JobLevelResponse> execute({int page = 1, int pageSize = 10}) {
    return repository.getJobLevels(page: page, pageSize: pageSize);
  }
}
