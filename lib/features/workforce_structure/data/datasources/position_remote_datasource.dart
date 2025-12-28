import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/position_model.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/position_response_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position_response.dart';

/// Position remote data source interface
abstract class PositionRemoteDataSource {
  Future<PositionResponse> getPositions({int page = 1, int pageSize = 10});
  Future<Position> createPosition(Map<String, dynamic> positionData);
  Future<void> deletePosition(int id, {bool hard = true});
}

/// Position remote data source implementation
class PositionRemoteDataSourceImpl implements PositionRemoteDataSource {
  final ApiClient apiClient;

  const PositionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.positions,
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );

    return PositionResponseModel.fromJson(response).toEntity();
  }

  @override
  Future<Position> createPosition(Map<String, dynamic> positionData) async {
    final response = await apiClient.post(
      ApiEndpoints.positions,
      body: positionData,
    );

    final data = response['data'] as Map<String, dynamic>;
    return PositionModel.fromJson(data).toEntity();
  }

  @override
  Future<void> deletePosition(int id, {bool hard = true}) async {
    await apiClient.delete(
      '${ApiEndpoints.positions}/$id',
      queryParameters: {'hard': hard.toString()},
    );
  }
}
