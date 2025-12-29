import 'package:digify_hr_system/core/network/api_client.dart';
import 'package:digify_hr_system/core/network/api_endpoints.dart';
import 'package:digify_hr_system/features/workforce_structure/data/dtos/org_structure_dto.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';

abstract class OrgStructureRemoteDataSource {
  Future<OrgStructure> getActiveOrgStructureLevels();
}

class OrgStructureRemoteDataSourceImpl implements OrgStructureRemoteDataSource {
  final ApiClient apiClient;

  const OrgStructureRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrgStructure> getActiveOrgStructureLevels() async {
    final response = await apiClient.get(ApiEndpoints.orgStructureLevels);

    return OrgStructureDto.fromJson(
      response['data'] as Map<String, dynamic>,
    ).toDomain();
  }
}
