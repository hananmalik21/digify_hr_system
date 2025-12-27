import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family_response.dart';

abstract class JobFamilyRemoteDataSource {
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10});
}

class JobFamilyRemoteDataSourceImpl implements JobFamilyRemoteDataSource {
  final ApiClient apiClient;

  const JobFamilyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobFamilyResponse> getJobFamilies({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.jobFamilies,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );

    return JobFamilyResponse.fromJson(response);
  }
}
