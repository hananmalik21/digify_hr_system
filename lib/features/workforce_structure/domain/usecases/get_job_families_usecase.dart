import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_family_repository.dart';

class GetJobFamiliesUseCase {
  final JobFamilyRepository repository;

  const GetJobFamiliesUseCase({required this.repository});

  Future<JobFamilyResponse> call({
    int page = 1,
    int pageSize = 10,
    String? search,
  }) async {
    return await repository.getJobFamilies(
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }
}
