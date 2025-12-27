import 'package:digify_hr_system/features/workforce_structure/data/datasources/job_family_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_family_repository.dart';

class JobFamilyRepositoryImpl implements JobFamilyRepository {
  final JobFamilyRemoteDataSource remoteDataSource;

  const JobFamilyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<JobFamilyResponse> getJobFamilies({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await remoteDataSource.getJobFamilies(
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) async {
    return await remoteDataSource.createJobFamily(
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      status: status,
    );
  }
}
