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

  // Time Management endpoints
  static const String attendances = '$api/attendances';
  static String attendanceById(int attendanceId) => '$attendances/$attendanceId';
  static const String checkIn = '$attendances/check-in';
  static String checkOut(int attendanceId) => '$attendances/$attendanceId/check-out';
  
  static const String timesheets = '$api/timesheets';
  static String timesheetById(int timesheetId) => '$timesheets/$timesheetId';
  static String submitTimesheet(int timesheetId) => '$timesheets/$timesheetId/submit';
  static String approveTimesheet(int timesheetId) => '$timesheets/$timesheetId/approve';
  static String rejectTimesheet(int timesheetId) => '$timesheets/$timesheetId/reject';
  
  static const String shifts = '$api/shifts';
  static String shiftById(int shiftId) => '$shifts/$shiftId';
  static String assignShift(int shiftId) => '$shifts/$shiftId/assign';
  static String removeShift(int shiftId, int employeeId) => '$shifts/$shiftId/assign/$employeeId';
  
  static const String timeOffRequests = '$api/time-off-requests';
  static String timeOffRequestById(int requestId) => '$timeOffRequests/$requestId';
  static String approveTimeOffRequest(int requestId) => '$timeOffRequests/$requestId/approve';
  static String rejectTimeOffRequest(int requestId) => '$timeOffRequests/$requestId/reject';
  static String cancelTimeOffRequest(int requestId) => '$timeOffRequests/$requestId/cancel';
  
  static const String overtimes = '$api/overtimes';
  static String overtimeById(int overtimeId) => '$overtimes/$overtimeId';
  static String approveOvertime(int overtimeId) => '$overtimes/$overtimeId/approve';
  static String rejectOvertime(int overtimeId) => '$overtimes/$overtimeId/reject';
  
  static const String timeStatistics = '$api/time-statistics';
}
