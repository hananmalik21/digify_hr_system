import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/job_family_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family_response.dart';

abstract class JobFamilyRemoteDataSource {
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10});
  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  });
  Future<JobFamily> updateJobFamily({
    required int id,
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  });
  Future<void> deleteJobFamily({required int id, bool hard = true});
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

  @override
  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.jobFamilies,
      body: {
        'job_family_code': code,
        'job_family_name_en': nameEnglish,
        'job_family_name_ar': nameArabic,
        'description': description,
        'status': status,
      },
    );

    final model = JobFamilyModel.fromJson(response['data']);
    return model.toEntity();
  }

  @override
  Future<JobFamily> updateJobFamily({
    required int id,
    required String code,
    required String nameEnglish,
    required String nameArabic,
    required String description,
    String status = 'ACTIVE',
  }) async {
    final response = await apiClient.put(
      '${ApiEndpoints.jobFamilies}/$id',
      body: {
        'job_family_code': code,
        'job_family_name_en': nameEnglish,
        'job_family_name_ar': nameArabic,
        'description': description,
        'status': status,
      },
    );

    final model = JobFamilyModel.fromJson(response['data']);
    return model.toEntity();
  }

  @override
  Future<void> deleteJobFamily({required int id, bool hard = true}) async {
    await apiClient.delete(
      '${ApiEndpoints.jobFamilies}/$id',
      queryParameters: {'hard': hard.toString()},
    );
  }
}
