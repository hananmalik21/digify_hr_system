import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_level_repository.dart';

class DeleteJobLevelUseCase {
  final JobLevelRepository repository;

  DeleteJobLevelUseCase(this.repository);

  Future<void> execute(int id) {
    return repository.deleteJobLevel(id);
  }
}
