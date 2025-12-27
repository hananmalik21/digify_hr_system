import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/active_structure_level_dto.dart';

/// Remote data source for organization structure level operations
abstract class OrgStructureLevelRemoteDataSource {
  Future<ActiveStructureResponseDto> getActiveLevels();
}

class OrgStructureLevelRemoteDataSourceImpl
    implements OrgStructureLevelRemoteDataSource {
  final ApiClient apiClient;

  OrgStructureLevelRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ActiveStructureResponseDto> getActiveLevels() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresActiveLevels,
      );

      // Parse response structure: { success, meta, data: { levels: [...] } }
      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return ActiveStructureResponseDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch active levels: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

