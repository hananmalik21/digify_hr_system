import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Use case for getting org units tree
class GetOrgUnitsTreeUseCase {
  final OrgUnitRepository repository;

  GetOrgUnitsTreeUseCase({required this.repository});

  /// Executes the use case to get org units tree
  ///
  /// Returns [OrgUnitTree]
  /// Throws [AppException] if the operation fails
  Future<OrgUnitTree> call() async {
    try {
      return await repository.getOrgUnitsTree();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get org units tree: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
