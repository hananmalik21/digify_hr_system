import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';

abstract class OrgStructureLevelRepository {
  Future<List<ActiveStructureLevel>> getActiveLevels({int? enterpriseId});
}
