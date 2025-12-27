import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';

/// Repository interface for organization structure level operations
abstract class OrgStructureLevelRepository {
  /// Gets active structure with levels
  ///
  /// Throws [AppException] if the operation fails
  Future<List<ActiveStructureLevel>> getActiveLevels();
}

