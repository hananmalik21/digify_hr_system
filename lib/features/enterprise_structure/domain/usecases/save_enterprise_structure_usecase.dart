import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/enterprise_structure_repository.dart';

/// Use case for saving enterprise structure
class SaveEnterpriseStructureUseCase {
  final EnterpriseStructureRepository repository;

  SaveEnterpriseStructureUseCase({required this.repository});

  /// Executes the use case to save enterprise structure
  /// 
  /// Returns the saved [EnterpriseStructure]
  /// Throws [AppException] if the operation fails
  Future<EnterpriseStructure> call(EnterpriseStructure structure) async {
    try {
      // Validate structure before saving
      if (structure.structureName.isEmpty) {
        throw ValidationException('Structure name is required');
      }
      if (structure.structureCode.isEmpty) {
        throw ValidationException('Structure code is required');
      }
      if (structure.levels.isEmpty) {
        throw ValidationException('At least one level is required');
      }

      return await repository.saveEnterpriseStructure(structure);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to save enterprise structure: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Updates an enterprise structure
  /// 
  /// Returns the updated [EnterpriseStructure]
  /// Throws [AppException] if the operation fails
  Future<EnterpriseStructure> updateStructure(
    String structureId,
    EnterpriseStructure structure,
  ) async {
    try {
      // Validate structure before updating
      if (structure.structureName.isEmpty) {
        throw ValidationException('Structure name is required');
      }
      if (structure.structureCode.isEmpty) {
        throw ValidationException('Structure code is required');
      }

      return await repository.updateEnterpriseStructure(structureId, structure);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update enterprise structure: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

