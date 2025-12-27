import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family_response.dart';

abstract class JobFamilyRepository {
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10});
}
