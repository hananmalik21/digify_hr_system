import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_family_repository.dart';

class UpdateJobFamilyUseCase {
  final JobFamilyRepository repository;

  const UpdateJobFamilyUseCase({required this.repository});

  Future<JobFamily> call({
    required int id,
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) async {
    return await repository.updateJobFamily(
      id: id,
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      status: status,
    );
  }
}
