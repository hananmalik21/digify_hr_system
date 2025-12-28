import 'package:digify_hr_system/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/org_structure_repository.dart';

class GetActiveOrgStructureLevelsUseCase {
  final OrgStructureRepository repository;

  const GetActiveOrgStructureLevelsUseCase({required this.repository});

  Future<OrgStructure> call() async {
    return await repository.getActiveOrgStructureLevels();
  }
}
