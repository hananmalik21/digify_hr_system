import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_family_repository.dart';

class DeleteJobFamilyUseCase {
  final JobFamilyRepository repository;

  const DeleteJobFamilyUseCase({required this.repository});

  Future<void> call({required int id, bool hard = true}) async {
    return await repository.deleteJobFamily(id: id, hard: hard);
  }
}
