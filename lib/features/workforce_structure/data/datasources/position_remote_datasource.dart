import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/models/position_response_model.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/position_response.dart';

/// Position remote data source interface
abstract class PositionRemoteDataSource {
  Future<PositionResponse> getPositions({int page = 1, int pageSize = 10});
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
}
