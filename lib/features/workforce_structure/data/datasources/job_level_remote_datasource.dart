import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/job_level_model.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/job_level_response_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level_response.dart';

abstract class JobLevelRemoteDataSource {
  Future<JobLevelResponse> getJobLevels({int page = 1, int pageSize = 10});
  Future<JobLevel> createJobLevel(Map<String, dynamic> data);
}

class JobLevelRemoteDataSourceImpl implements JobLevelRemoteDataSource {
  final ApiClient apiClient;

  const JobLevelRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobLevelResponse> getJobLevels({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.jobLevels,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );

    return JobLevelResponseModel.fromJson(response);
  }

  @override
  Future<JobLevel> createJobLevel(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.jobLevels, body: data);

    return JobLevelModel.fromJson(
      response['data'] as Map<String, dynamic>,
    ).toEntity();
  }
}
