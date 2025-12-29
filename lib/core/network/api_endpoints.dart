/// Centralized API endpoints for the entire application
/// All endpoints should be defined here to maintain consistency
class ApiEndpoints {
  ApiEndpoints._();

  // Base API path
  static const String api = '/api';

  // Enterprise Structure endpoints
  static const String structureLevels = '$api/structure-levels';
  static const String hrOrgStructures = '$api/hr-org-structures';
  static const String hrOrgStructuresActiveLevels =
      '$hrOrgStructures/active/levels';
  static String hrOrgStructuresUnitsByLevel(String levelCode) =>
      '$hrOrgStructuresActiveLevels/$levelCode/units';
  static String hrOrgStructuresUnitsByStructureAndLevel(
    int structureId,
    String levelCode,
  ) => '$hrOrgStructures/$structureId/org-units';
  static String hrOrgStructuresParentUnits(int structureId, String levelCode) =>
      '$hrOrgStructures/$structureId/org-units/parents';
  static String hrOrgStructuresCreateUnit(int structureId) =>
      '$hrOrgStructures/$structureId/org-units';
  static String hrOrgStructuresUpdateUnit(int structureId, int orgUnitId) =>
      '$hrOrgStructures/$structureId/org-units/$orgUnitId';
  static String hrOrgStructuresDeleteUnit(int structureId, int orgUnitId) =>
      '$hrOrgStructures/$structureId/org-units/$orgUnitId';
  static const String hrOrgStructuresActiveUnits =
      '$hrOrgStructures/active/units';
  static const String enterprises = '$api/enterprises';
  static const String companies = '$api/companies';
  static const String divisions = '$api/divisions';
  static const String businessUnits = '$api/business-units';
  static const String departments = '$api/departments';

  // Workforce Structure endpoints
  static const String jobFamilies = '$api/job-families';
  static const String jobLevels = '$api/job-levels';
  static const String grades = '$api/grades';
  static const String positions = '$api/positions';

  // Organization Structure Levels (alias for convenience)
  static const String orgStructureLevels = hrOrgStructuresActiveLevels;
}
