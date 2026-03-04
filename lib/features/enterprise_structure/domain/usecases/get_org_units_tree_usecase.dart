import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

class GetOrgUnitsTreeUseCase {
  final OrgUnitRepository repository;

  GetOrgUnitsTreeUseCase({required this.repository});

  Future<OrgUnitTree> call({int? enterpriseId}) async {
    try {
      return await repository.getOrgUnitsTree(enterpriseId: enterpriseId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get org units tree: ${e.toString()}', originalError: e);
    }
  }
}
