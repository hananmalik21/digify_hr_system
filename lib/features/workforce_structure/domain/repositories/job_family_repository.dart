import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family_response.dart';

abstract class JobFamilyRepository {
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10});
  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  });
}
