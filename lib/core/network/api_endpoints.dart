/// Centralized API endpoints for the entire application
/// All endpoints should be defined here to maintain consistency
class ApiEndpoints {
  ApiEndpoints._();

  // Base API path
  static const String api = '/api';

  // Enterprise Structure endpoints
  static const String structureLevels = '$api/structure-levels';
  static const String hrOrgStructures = '$api/hr-org-structures';
  static const String hrOrgStructuresActiveLevels = '$hrOrgStructures/active/levels';
  static String hrOrgStructuresUnitsByLevel(String levelCode) => '$hrOrgStructuresActiveLevels/$levelCode/units';
  static String hrOrgStructuresUnitsByStructureAndLevel(String structureId, String levelCode) =>
      '$hrOrgStructures/$structureId/org-units';
  static String hrOrgStructuresParentUnits(String structureId, String levelCode) =>
      '$hrOrgStructures/$structureId/org-units/parents';
  static String hrOrgStructuresCreateUnit(String structureId) => '$hrOrgStructures/$structureId/org-units';
  static String hrOrgStructuresUpdateUnit(String structureId, String orgUnitId) =>
      '$hrOrgStructures/$structureId/org-units/$orgUnitId';
  static String hrOrgStructuresDeleteUnit(String structureId, String orgUnitId) =>
      '$hrOrgStructures/$structureId/org-units/$orgUnitId';
  static String hrOrgStructuresDelete(String structureId) => '$hrOrgStructures/$structureId';
  static const String hrOrgStructuresActiveUnits = '$hrOrgStructures/active/units';
  static const String orgUnitsTreeActive = '$api/org-units/tree/active';
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
  static const String workforceStats = '$api/workforce-stats';
  static const String employees = '$api/employees';
  static const String createEmployee = '$api/create-employee';

  // Employee (empl) lookups
  static const String emplLookupTypes = '$api/empl/lookup-types';
  static const String emplLookupValues = '$api/empl/lookup-values';

  // Organization Structure Levels (alias for convenience)
  static const String orgStructureLevels = hrOrgStructuresActiveLevels;

  // Time Management (TM) endpoints
  static const String tmShifts = '$api/tm/shifts';
  static String tmShiftById(int shiftId) => '$tmShifts/$shiftId';
  static const String tmWorkPatterns = '$api/tm/work-patterns';
  static const String tmWorkSchedules = '$api/tm/work-schedules';
  static String tmWorkScheduleById(int scheduleId) => '$tmWorkSchedules/$scheduleId';
  static const String tmScheduleAssignments = '$api/tm/schedule-assignments';
  static String tmScheduleAssignmentById(int scheduleAssignmentId) => '$tmScheduleAssignments/$scheduleAssignmentId';
  static const String tmPublicHolidays = '$api/holidays';
  static String tmPublicHolidayById(int holidayId) => '$tmPublicHolidays/$holidayId';
  static const String tmStats = '$api/tm/stats';

  // Leave Management (ABS) endpoints
  static const String absLeaveRequests = '$api/abs/leave-requests';
  static String absLeaveRequestById(String guid) => '$absLeaveRequests/$guid';
  static String absLeaveRequestApprove(String guid) => '$absLeaveRequests/$guid/approve';
  static String absLeaveRequestReject(String guid) => '$absLeaveRequests/$guid/reject';
  static String absLeaveRequestDelete(String guid) => '$absLeaveRequests/$guid';
  static String absLeaveRequestUpdate(String guid) => '$absLeaveRequests/$guid';
  static const String absLeaveTypes = '$api/abs/leave-types';
  static const String absLeaveBalances = '$api/abs/leave-balances';
  static String absLeaveBalanceUpdate(String employeeLeaveBalanceGuid) => '$absLeaveBalances/$employeeLeaveBalanceGuid';
  static const String absLeavePolicies = '$api/abs/leave-policies';
  static String absLeavePolicyUpdate(String policyGuid) => '$absLeavePolicies/$policyGuid';
  static const String absPolicies = '$api/abs/policies';
  static const String absCreatePolicy = '$api/abs/create-policy';
  static String absUpdatePolicy(String policyGuid) => '$api/abs/update-policy/$policyGuid';
  static const String absLookups = '$api/abs/lookups';
  static String absLookupValues(int lookupId) => '$absLookups/$lookupId/values';
}
