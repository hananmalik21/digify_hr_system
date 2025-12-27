import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/paginated_org_units_response.dart';

/// Repository interface for organization unit operations
abstract class OrgUnitRepository {
  /// Gets list of org units by level code
  ///
  /// Throws [AppException] if the operation fails
  Future<List<OrgStructureLevel>> getOrgUnitsByLevel(String levelCode);
  
  /// Gets list of org units by structure ID and level code
  ///
  /// Throws [AppException] if the operation fails
  Future<List<OrgStructureLevel>> getOrgUnitsByStructureAndLevel(int structureId, String levelCode);

  /// Gets paginated list of org units by structure ID and level code with search
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedOrgUnitsResponse> getOrgUnitsByStructureAndLevelPaginated(
    int structureId,
    String levelCode, {
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets list of parent org units for a given structure and level
  ///
  /// Throws [AppException] if the operation fails
  Future<List<OrgStructureLevel>> getParentOrgUnits(int structureId, String levelCode);

  /// Creates a new org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<OrgStructureLevel> createOrgUnit(int structureId, Map<String, dynamic> data);

  /// Updates an existing org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<OrgStructureLevel> updateOrgUnit(int structureId, int orgUnitId, Map<String, dynamic> data);

  /// Deletes an org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<void> deleteOrgUnit(int structureId, int orgUnitId, {bool hard = true});
}

