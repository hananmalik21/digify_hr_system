import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/save_enterprise_structure_dto.dart';

/// Remote data source for enterprise structure operations
abstract class EnterpriseStructureRemoteDataSource {
  Future<Map<String, dynamic>> saveEnterpriseStructure(
    SaveEnterpriseStructureRequestDto request,
  );
}

class EnterpriseStructureRemoteDataSourceImpl
    implements EnterpriseStructureRemoteDataSource {
  final ApiClient apiClient;

  EnterpriseStructureRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> saveEnterpriseStructure(
    SaveEnterpriseStructureRequestDto request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.hrOrgStructures,
        body: request.toJson(),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to save enterprise structure: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

