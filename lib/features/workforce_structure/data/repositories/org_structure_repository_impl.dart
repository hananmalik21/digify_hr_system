import 'package:digify_hr_system/features/workforce_structure/data/datasources/org_structure_remote_datasource.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/org_structure_repository.dart';

class OrgStructureRepositoryImpl implements OrgStructureRepository {
  final OrgStructureRemoteDataSource remoteDataSource;

  const OrgStructureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrgStructure> getActiveOrgStructureLevels() async {
    return await remoteDataSource.getActiveOrgStructureLevels();
  }

  @override
  Future<List<OrgStructure>> getOrgStructuresByEnterpriseId(int enterpriseId) async {
    return await remoteDataSource.getOrgStructuresByEnterpriseId(enterpriseId);
  }
}
