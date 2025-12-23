import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/enterprise_dto.dart';

/// Remote data source for enterprise operations
abstract class EnterpriseRemoteDataSource {
  Future<List<EnterpriseDto>> getEnterprises();
}

class EnterpriseRemoteDataSourceImpl implements EnterpriseRemoteDataSource {
  final ApiClient apiClient;

  EnterpriseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<EnterpriseDto>> getEnterprises() async {
    try {
      final response = await apiClient.get(ApiEndpoints.enterprises);

      // Handle different response formats
      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('enterprises') &&
          response['enterprises'] is List) {
        data = response['enterprises'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data
          .where((item) => item is Map<String, dynamic>)
          .map((json) => EnterpriseDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch enterprises: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

