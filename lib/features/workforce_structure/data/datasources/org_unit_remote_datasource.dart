import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/features/workforce_structure/data/dtos/org_unit_dto.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';

abstract class OrgUnitRemoteDataSource {
  Future<OrgUnitsResponse> getOrgUnitsByLevel({
    required String structureId,
    required String levelCode,
    String? parentOrgUnitId,
    String? search,
    int page = 1,
    int pageSize = 100,
  });
}

class OrgUnitRemoteDataSourceImpl implements OrgUnitRemoteDataSource {
  final ApiClient apiClient;

  const OrgUnitRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrgUnitsResponse> getOrgUnitsByLevel({
    required String structureId,
    required String levelCode,
    String? parentOrgUnitId,
    String? search,
    int page = 1,
    int pageSize = 100,
  }) async {
    final queryParams = {'level': levelCode, 'page': page.toString(), 'page_size': pageSize.toString()};

    if (parentOrgUnitId != null) {
      queryParams['parentId'] = parentOrgUnitId.toString();
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await apiClient.get('/api/hr-org-structures/$structureId/org-units', queryParameters: queryParams);

    return OrgUnitsResponseDto.fromJson(response).toDomain();
  }
}
