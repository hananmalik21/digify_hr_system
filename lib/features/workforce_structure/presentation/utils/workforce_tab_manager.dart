import 'package:digify_hr_system/core/enums/workforce_enums.dart';

class WorkforceTabManager {
  static WorkforceTab getTabFromRoute(String? routeTab) {
    if (routeTab == null) return WorkforceTab.positions;

    switch (routeTab) {
      case 'positions':
        return WorkforceTab.positions;
      case 'jobFamilies':
        return WorkforceTab.jobFamilies;
      case 'jobLevels':
        return WorkforceTab.jobLevels;
      case 'gradeStructure':
        return WorkforceTab.gradeStructure;
      case 'reportingStructure':
        return WorkforceTab.reportingStructure;
      case 'positionTree':
        return WorkforceTab.positionTree;
      default:
        return WorkforceTab.positions;
    }
  }
}
