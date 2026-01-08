import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
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
  Future<List<OrgStructureLevel>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode);

  /// Gets paginated list of org units by structure ID and level code with search
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedOrgUnitsResponse> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets list of parent org units for a given structure and level
  ///
  /// Throws [AppException] if the operation fails
  Future<List<OrgStructureLevel>> getParentOrgUnits(String structureId, String levelCode);

  /// Creates a new org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<OrgStructureLevel> createOrgUnit(String structureId, Map<String, dynamic> data);

  /// Updates an existing org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<OrgStructureLevel> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data);

  /// Deletes an org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true});

  /// Gets the org units tree for active structure
  ///
  /// Throws [AppException] if the operation fails
  Future<OrgUnitTree> getOrgUnitsTree();
}

