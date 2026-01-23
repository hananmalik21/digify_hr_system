mixin TabIndexMixin {
  int? getTimeManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'shifts':
        return 0;
      case 'workPatterns':
        return 1;
      case 'workSchedules':
        return 2;
      case 'scheduleAssignments':
        return 3;
      case 'viewCalendar':
        return 4;
      case 'publicHolidays':
        return 5;
      default:
        return null;
    }
  }

  int? getWorkforceStructureTabIndex(String itemId) {
    switch (itemId) {
      case 'positions':
        return 0;
      case 'jobFamilies':
        return 1;
      case 'jobLevels':
        return 2;
      case 'gradeStructure':
        return 3;
      case 'reportingStructure':
        return 4;
      case 'positionTree':
        return 5;
      default:
        return null;
    }
  }

  int? getLeaveManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'leaveRequests':
        return 0;
      case 'leaveBalance':
        return 1;
      case 'myLeaveBalance':
        return 2;
      case 'teamLeaveRisk':
        return 3;
      case 'leavePolicies':
        return 4;
      case 'policyConfiguration':
        return 5;
      case 'forfeitPolicy':
        return 6;
      case 'forfeitProcessing':
        return 7;
      case 'forfeitReports':
        return 8;
      case 'leaveCalendar':
        return 9;
      default:
        return null;
    }
  }
}
