import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/grade_model.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/grade_response_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade_response.dart';

abstract class GradeRemoteDataSource {
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10});
  Future<Grade> createGrade(Map<String, dynamic> data);
  Future<Grade> updateGrade(int gradeId, Map<String, dynamic> data);
  Future<void> deleteGrade(int gradeId);
}

class GradeRemoteDataSourceImpl implements GradeRemoteDataSource {
  final ApiClient apiClient;

  const GradeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10}) async {
    final response = await apiClient.get(
      ApiEndpoints.grades,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );

    return GradeResponseModel.fromJson(response).toEntity();
  }

  @override
  Future<Grade> createGrade(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.grades, body: data);

    return GradeModel.fromJson(
      response['data'] as Map<String, dynamic>,
    ).toEntity();
  }

  @override
  Future<Grade> updateGrade(int gradeId, Map<String, dynamic> data) async {
    final response = await apiClient.put(
      '${ApiEndpoints.grades}/$gradeId',
      body: data,
    );

    return GradeModel.fromJson(
      response['data'] as Map<String, dynamic>,
    ).toEntity();
  }

  @override
  Future<void> deleteGrade(int gradeId) async {
    await apiClient.delete(
      '${ApiEndpoints.grades}/$gradeId',
      queryParameters: {'hard': 'true'},
    );
  }
}
