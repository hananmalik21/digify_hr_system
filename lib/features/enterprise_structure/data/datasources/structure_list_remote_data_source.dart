import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/structure_list_dto.dart';

/// Remote data source for structure list operations
abstract class StructureListRemoteDataSource {
  Future<PaginatedStructureListDto> getStructures({
    int page = 1,
    int pageSize = 10,
  });
}

class StructureListRemoteDataSourceImpl
    implements StructureListRemoteDataSource {
  final ApiClient apiClient;

  StructureListRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedStructureListDto> getStructures({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructures,
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      return PaginatedStructureListDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch structures: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

