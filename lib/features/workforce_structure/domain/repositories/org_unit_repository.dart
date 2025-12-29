import 'package:digify_hr_system/features/workforce_structure/domain/models/org_unit.dart';

abstract class OrgUnitRepository {
  Future<OrgUnitsResponse> getOrgUnitsByLevel({
    required int structureId,
    required String levelCode,
    int? parentOrgUnitId,
    int page = 1,
    int pageSize = 100,
  });
}
