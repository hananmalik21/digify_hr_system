import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/org_unit_repository.dart';

class GetOrgUnitsByLevelUseCase {
  final OrgUnitRepository repository;

  const GetOrgUnitsByLevelUseCase({required this.repository});

  Future<OrgUnitsResponse> call({
    required String structureId,
    required String levelCode,
    String? parentOrgUnitId,
    String? search,
    int page = 1,
    int pageSize = 100,
  }) async {
    return await repository.getOrgUnitsByLevel(
      structureId: structureId,
      levelCode: levelCode,
      parentOrgUnitId: parentOrgUnitId,
      search: search,
      page: page,
      pageSize: pageSize,
    );
  }
}
