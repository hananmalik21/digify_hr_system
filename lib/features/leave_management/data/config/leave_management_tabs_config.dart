import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class LeaveManagementTab {
  final String id;
  final String labelKey;
  final String iconPath;

  const LeaveManagementTab({
    required this.id,
    required this.labelKey,
    required this.iconPath,
  });
}

class LeaveManagementTabsConfig {
  static  List<LeaveManagementTab> tabs = [
    LeaveManagementTab(
      id: 'leaveRequests',
      labelKey: 'leaveRequests',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(
      id: 'leaveBalance',
      labelKey: 'leaveBalance',
      iconPath: Assets.icons.leaveManagementIcon.path, // TODO: Update with leaveBalanceIcon when available
    ),
    LeaveManagementTab(
      id: 'teamLeaveRisk',
      labelKey: 'teamLeaveRisk',
      iconPath: Assets.icons.leaveManagementIcon.path, // TODO: Update with teamLeaveRiskIcon when available
    ),
  ];

  static List<LeaveManagementTab> getTabs() {
    return tabs;
  }

  static String getLocalizedLabel(String labelKey, AppLocalizations localizations) {
    switch (labelKey) {
      case 'leaveRequests':
        return localizations.leaveRequests;
      case 'leaveBalance':
        return localizations.leaveBalance;
      case 'teamLeaveRisk':
        return localizations.teamLeaveRisk;
      default:
        return labelKey;
    }
  }
}
