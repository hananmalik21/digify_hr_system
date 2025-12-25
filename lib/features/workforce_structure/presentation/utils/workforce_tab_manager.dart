import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';

class WorkforceTabManager {
  static String getTabFromRoute(
    String? routeTab,
    AppLocalizations localizations,
  ) {
    if (routeTab == null) return localizations.positions;

    switch (routeTab) {
      case 'positions':
        return localizations.positions;
      case 'jobFamilies':
        return localizations.jobFamilies;
      case 'jobLevels':
        return localizations.jobLevels;
      case 'gradeStructure':
        return localizations.gradeStructure;
      case 'reportingStructure':
        return localizations.reportingStructure;
      case 'positionTree':
        return localizations.positionTree;
      default:
        return localizations.positions;
    }
  }
}
