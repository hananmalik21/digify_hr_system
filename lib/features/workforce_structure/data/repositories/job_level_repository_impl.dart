import 'package:digify_hr_system/features/workforce_structure/data/datasources/job_level_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/job_level_repository.dart';

class JobLevelRepositoryImpl implements JobLevelRepository {
  final JobLevelRemoteDataSource remoteDataSource;

  const JobLevelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<JobLevelResponse> getJobLevels({
    int page = 1,
    int pageSize = 10,
  }) async {
    return await remoteDataSource.getJobLevels(page: page, pageSize: pageSize);
  }

  @override
  Future<JobLevel> createJobLevel(JobLevel jobLevel) async {
    final data = {
      'level_name_en': jobLevel.nameEn,
      'level_code': jobLevel.code,
      'description': jobLevel.description,
      'min_grade_id': jobLevel.minGradeId,
      'max_grade_id': jobLevel.maxGradeId,
      'status': jobLevel.status,
      'last_update_login': 'SYSTEM',
    };
    return await remoteDataSource.createJobLevel(data);
  }

  @override
  Future<JobLevel> updateJobLevel(JobLevel jobLevel) async {
    final data = {
      'description': jobLevel.description,
      'min_grade_id': jobLevel.minGradeId,
      'max_grade_id': jobLevel.maxGradeId,
    };
    return await remoteDataSource.updateJobLevel(jobLevel.id, data);
  }

  @override
  Future<void> deleteJobLevel(int id) async {
    await remoteDataSource.deleteJobLevel(id, hard: true);
  }
}
