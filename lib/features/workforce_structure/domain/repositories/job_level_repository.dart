import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';

abstract class JobLevelRepository {
  Future<JobLevelResponse> getJobLevels({int page = 1, int pageSize = 10});
  Future<JobLevel> createJobLevel(JobLevel jobLevel);
  Future<JobLevel> updateJobLevel(JobLevel jobLevel);
  Future<void> deleteJobLevel(int id);
}
