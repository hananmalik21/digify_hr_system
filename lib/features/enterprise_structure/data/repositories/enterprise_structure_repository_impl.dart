import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/enterprise_structure_remote_data_source.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/dto/save_enterprise_structure_dto.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/repositories/enterprise_structure_repository.dart';

/// Implementation of EnterpriseStructureRepository
class EnterpriseStructureRepositoryImpl
    implements EnterpriseStructureRepository {
  final EnterpriseStructureRemoteDataSource remoteDataSource;

  EnterpriseStructureRepositoryImpl({required this.remoteDataSource});

  @override
  Future<EnterpriseStructure> saveEnterpriseStructure(
    EnterpriseStructure structure,
  ) async {
    try {
      // Convert domain model to DTO
      final requestDto = SaveEnterpriseStructureRequestDto(
        enterpriseId: structure.enterpriseId,
        structureCode: structure.structureCode,
        structureName: structure.structureName,
        structureType: structure.structureType,
        description: structure.description,
        isActive: structure.isActive,
        levels: structure.levels
            .map((level) => StructureLevelDto(
                  structureLevelId: level.structureLevelId,
                  levelNumber: level.levelNumber,
                  displayOrder: level.displayOrder,
                ))
            .toList(),
      );

      await remoteDataSource.saveEnterpriseStructure(requestDto);

      // Convert response to domain model
      // Assuming the API returns the saved structure
      return structure; // Return the structure as-is, or parse from response if needed
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<EnterpriseStructure> updateEnterpriseStructure(
    int structureId,
    EnterpriseStructure structure,
  ) async {
    try {
      // Convert domain model to DTO
      final requestDto = SaveEnterpriseStructureRequestDto(
        enterpriseId: structure.enterpriseId,
        structureCode: structure.structureCode,
        structureName: structure.structureName,
        structureType: structure.structureType,
        description: structure.description,
        isActive: structure.isActive,
        levels: structure.levels
            .map((level) => StructureLevelDto(
                  structureLevelId: level.structureLevelId,
                  levelNumber: level.levelNumber,
                  displayOrder: level.displayOrder,
                ))
            .toList(),
      );

      await remoteDataSource.updateEnterpriseStructure(structureId, requestDto);

      // Convert response to domain model
      // Assuming the API returns the updated structure
      return structure; // Return the structure as-is, or parse from response if needed
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

