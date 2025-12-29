import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';

abstract class OrgStructureRepository {
  Future<OrgStructure> getActiveOrgStructureLevels();
}
