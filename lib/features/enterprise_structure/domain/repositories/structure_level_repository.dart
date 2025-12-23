import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_level.dart';

/// Repository interface for structure levels
/// Defines the contract for data access in the domain layer
abstract class StructureLevelRepository {
  /// Fetches all structure levels from the remote source
  /// 
  /// Throws [AppException] if the operation fails
  Future<List<StructureLevel>> getStructureLevels();
}

