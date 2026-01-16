import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class LeaveManagementTab {
  final String id;
  final String labelKey;
  final String iconPath;

  const LeaveManagementTab({required this.id, required this.labelKey, required this.iconPath});
}

class LeaveManagementTabsConfig {
  static List<LeaveManagementTab> tabs = [
    LeaveManagementTab(id: 'leaveRequests', labelKey: 'leaveRequests', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'leaveBalance', labelKey: 'leaveBalance', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'teamLeaveRisk', labelKey: 'teamLeaveRisk', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'leaveCalendar', labelKey: 'leaveCalendar', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'leavePolicies', labelKey: 'leavePolicies', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(id: 'leaveReports', labelKey: 'leaveReports', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(
      id: 'leaveApprovals',
      labelKey: 'leaveApprovals',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(id: 'leaveHistory', labelKey: 'leaveHistory', iconPath: Assets.icons.leaveManagementIcon.path),
    LeaveManagementTab(
      id: 'leaveEntitlements',
      labelKey: 'leaveEntitlements',
      iconPath: Assets.icons.leaveManagementIcon.path,
    ),
    LeaveManagementTab(id: 'leaveSettings', labelKey: 'leaveSettings', iconPath: Assets.icons.leaveManagementIcon.path),
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
      case 'leaveCalendar':
        return localizations.leaveCalendar;
      case 'leavePolicies':
        return localizations.leavePolicies;
      case 'leaveReports':
        return 'Leave Reports';
      case 'leaveApprovals':
        return 'Leave Approvals';
      case 'leaveHistory':
        return 'Leave History';
      case 'leaveEntitlements':
        return 'Leave Entitlements';
      case 'leaveSettings':
        return 'Leave Settings';
      default:
        return labelKey;
    }
  }
}
