import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/position_model.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/position_response_model.dart';
import 'package:digify_hr_system/core/enums/position_status.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position_response.dart';

/// Position remote data source interface
abstract class PositionRemoteDataSource {
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
  });
  Future<Position> createPosition(Map<String, dynamic> positionData);
  Future<Position> updatePosition(String id, Map<String, dynamic> positionData);
  Future<void> deletePosition(String id, {bool hard = true});
}

/// Position remote data source implementation
class PositionRemoteDataSourceImpl implements PositionRemoteDataSource {
  final ApiClient apiClient;

  const PositionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    if (status != null) {
      queryParameters['status'] = status.name;
    }

    final response = await apiClient.get(
      ApiEndpoints.positions,
      queryParameters: queryParameters,
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
  Future<Position> updatePosition(
    String id,
    Map<String, dynamic> positionData,
  ) async {
    final response = await apiClient.put(
      '${ApiEndpoints.positions}/$id',
      body: positionData,
    );

    final data = response['data'] as Map<String, dynamic>;
    return PositionModel.fromJson(data).toEntity();
  }

  @override
  Future<void> deletePosition(String id, {bool hard = true}) async {
    await apiClient.delete(
      '${ApiEndpoints.positions}/$id',
      queryParameters: {'hard': hard.toString()},
    );
  }
}
