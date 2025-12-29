import 'package:digify_hr_system/features/workforce_structure/data/datasources/org_unit_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/org_unit_repository.dart';

class OrgUnitRepositoryImpl implements OrgUnitRepository {
  final OrgUnitRemoteDataSource remoteDataSource;

  const OrgUnitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrgUnitsResponse> getOrgUnitsByLevel({
    required int structureId,
    required String levelCode,
    int? parentOrgUnitId,
    String? search,
    int page = 1,
    int pageSize = 100,
  }) async {
    return await remoteDataSource.getOrgUnitsByLevel(
      structureId: structureId,
      levelCode: levelCode,
      parentOrgUnitId: parentOrgUnitId,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
