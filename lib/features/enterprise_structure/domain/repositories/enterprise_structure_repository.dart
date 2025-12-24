import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise_structure.dart';

/// Repository interface for enterprise structure operations
abstract class EnterpriseStructureRepository {
  /// Saves an enterprise structure
  /// 
  /// Throws [AppException] if the operation fails
  Future<EnterpriseStructure> saveEnterpriseStructure(
    EnterpriseStructure structure,
  );
  
  /// Updates an enterprise structure
  /// 
  /// Throws [AppException] if the operation fails
  Future<EnterpriseStructure> updateEnterpriseStructure(
    int structureId,
    EnterpriseStructure structure,
  );
}

