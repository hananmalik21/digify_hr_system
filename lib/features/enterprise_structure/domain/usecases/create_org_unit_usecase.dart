import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Use case for creating an org unit
class CreateOrgUnitUseCase {
  final OrgUnitRepository repository;

  CreateOrgUnitUseCase({required this.repository});

  /// Executes the use case to create an org unit
  ///
  /// Returns the created [OrgStructureLevel]
  /// Throws [AppException] if the operation fails
  Future<OrgStructureLevel> call(int structureId, Map<String, dynamic> data) async {
    try {
      return await repository.createOrgUnit(structureId, data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create org unit for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

