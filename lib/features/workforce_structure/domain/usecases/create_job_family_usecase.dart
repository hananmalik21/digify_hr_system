import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_family_repository.dart';

class CreateJobFamilyUseCase {
  final JobFamilyRepository repository;

  const CreateJobFamilyUseCase({required this.repository});

  Future<JobFamily> call({
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) async {
    return await repository.createJobFamily(
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      status: status,
    );
  }
}
