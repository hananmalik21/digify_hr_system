import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/menu_feature_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class SidebarConfig {
  static List<SidebarItem> _filterItems(List<SidebarItem> items) {
    final result = <SidebarItem>[];
    for (final item in items) {
      if (!MenuFeatureConfig.isEnabled(item.id)) continue;
      if (item.children != null) {
        final filteredChildren = _filterItems(item.children!);
        if (filteredChildren.isEmpty) continue;
        result.add(
          SidebarItem(
            id: item.id,
            icon: item.icon,
            svgPath: item.svgPath,
            labelKey: item.labelKey,
            children: filteredChildren,
            route: item.route,
            subtitle: item.subtitle,
          ),
        );
      } else {
        result.add(item);
      }
    }
    return result;
  }

  static List<SidebarItem> getMenuItems() {
    return _filterItems([
      SidebarItem(
        id: 'dashboard',
        svgPath: Assets.icons.dashboardIcon.path,
        labelKey: 'dashboard',
        children: [
          SidebarItem(
            id: 'overview',
            svgPath: Assets.icons.overviewIcon.path,
            labelKey: 'overview',
            route: '/dashboard/overview',
          ),
          SidebarItem(
            id: 'analytics',
            svgPath: Assets.icons.analyticsIcon.path,
            labelKey: 'analytics',
            route: '/dashboard/analytics',
          ),
          SidebarItem(
            id: 'quickActions',
            svgPath: Assets.icons.quickActionsIcon.path,
            labelKey: 'quickActions',
            route: '/dashboard/quick-actions',
          ),
        ],
      ),
      SidebarItem(
        id: 'moduleCatalogue',
        svgPath: Assets.icons.moduleCatalogueIcon.path,
        labelKey: 'moduleCatalogue',
        route: '/module-catalogue',
      ),
      SidebarItem(
        id: 'productIntro',
        svgPath: Assets.icons.productIntroIcon.path,
        labelKey: 'productIntro',
        route: '/product-intro',
      ),
      SidebarItem(
        id: 'enterpriseStructure',
        svgPath: Assets.icons.enterpriseStructureIcon.path,
        labelKey: 'enterpriseStructure',
        children: [
          SidebarItem(
            id: 'manageEnterpriseStructure',
            svgPath: Assets.icons.manageEnterpriseIcon.path,
            labelKey: 'manageEnterpriseStructure',
            route: '/enterprise-structure/manage',
          ),
          SidebarItem(
            id: 'manageComponentValues',
            svgPath: Assets.icons.manageComponentIcon.path,
            labelKey: 'manageComponentValues',
            route: '/enterprise-structure/component-values',
          ),
          SidebarItem(
            id: 'company',
            svgPath: Assets.icons.companyIcon.path,
            labelKey: 'company',
            route: '/enterprise-structure/company',
          ),
          SidebarItem(
            id: 'division',
            svgPath: Assets.icons.divisionIcon.path,
            labelKey: 'division',
            route: '/enterprise-structure/division',
          ),
          SidebarItem(
            id: 'businessUnit',
            svgPath: Assets.icons.businessUnitIcon.path,
            labelKey: 'businessUnit',
            route: '/enterprise-structure/business-unit',
          ),
          SidebarItem(
            id: 'department',
            svgPath: Assets.icons.departmentIcon.path,
            labelKey: 'department',
            route: '/enterprise-structure/department',
          ),
          SidebarItem(
            id: 'section',
            svgPath: Assets.icons.sectionIcon.path,
            labelKey: 'section',
            route: '/enterprise-structure/section',
          ),
        ],
      ),
      SidebarItem(
        id: 'workforceStructure',
        svgPath: Assets.icons.workforceStructureIcon.path,
        labelKey: 'workforceStructure',
        children: [
          SidebarItem(
            id: 'positions',
            svgPath: Assets.icons.businessUnitIcon.path,
            labelKey: 'positions',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'jobFamilies',
            svgPath: Assets.icons.workforce.workforceTab.path,
            labelKey: 'jobFamilies',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'jobLevels',
            svgPath: Assets.icons.workforce.fillRate.path,
            labelKey: 'jobLevels',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'gradeStructure',
            svgPath: Assets.icons.sidebar.gradeSidebar.path,
            labelKey: 'gradeStructure',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'reportingStructure',
            svgPath: Assets.icons.companyIcon.path,
            labelKey: 'reportingStructure',
            route: '/workforce-structure',
          ),
          SidebarItem(
            id: 'positionTree',
            svgPath: Assets.icons.positionsIcon.path,
            labelKey: 'positionTree',
            route: '/workforce-structure',
          ),
        ],
      ),
      SidebarItem(
        id: 'timeManagement',
        svgPath: Assets.icons.clockIcon.path,
        labelKey: 'timeManagement',
        children: [
          SidebarItem(
            id: 'shifts',
            svgPath: Assets.icons.clockIcon.path,
            labelKey: 'shifts',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'workPatterns',
            svgPath: Assets.icons.leaveManagementIcon.path,
            labelKey: 'workPatterns',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'workSchedules',
            svgPath: Assets.icons.sidebar.workSchedules.path,
            labelKey: 'workSchedules',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'scheduleAssignments',
            svgPath: Assets.icons.sidebar.scheduleAssignments.path,
            labelKey: 'scheduleAssignments',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'viewCalendar',
            svgPath: Assets.icons.sidebar.workSchedules.path,
            labelKey: 'viewCalendar',
            route: '/time-management',
          ),
          SidebarItem(
            id: 'publicHolidays',
            svgPath: Assets.icons.sidebar.publicHolidays.path,
            labelKey: 'publicHolidays',
            route: '/time-management',
          ),
        ],
      ),
      SidebarItem(
        id: 'employees',
        svgPath: Assets.icons.employeesIcon.path,
        labelKey: 'employees',
        children: [
          SidebarItem(
            id: 'manageEmployees',
            svgPath: Assets.icons.employeeListIcon.path,
            labelKey: 'manageEmployees',
            route: '/employees',
            subtitle: 'View & manage employees',
          ),
          SidebarItem(
            id: 'employeeActions',
            svgPath: Assets.icons.employeeActionsIcon.path,
            labelKey: 'employeeActions',
            route: '/employees',
            subtitle: '60+ lifecycle actions',
          ),
          SidebarItem(
            id: 'workforcePlanning',
            svgPath: Assets.icons.workforcePlanningIcon.path,
            labelKey: 'workforcePlanning',
            route: '/employees',
            subtitle: 'Headcount planning',
          ),
          SidebarItem(
            id: 'contracts',
            svgPath: Assets.icons.contractsIcon.path,
            labelKey: 'contracts',
            route: '/employees',
            subtitle: 'Digital contract management',
          ),
        ],
      ),
      SidebarItem(
        id: 'leaveManagement',
        svgPath: Assets.icons.leaveManagementIcon.path,
        labelKey: 'leaveManagement',
        children: [
          SidebarItem(
            id: 'leaveRequests',
            svgPath: Assets.icons.leaveManagement.leaveRequests.path,
            labelKey: 'leaveRequests',
            route: '/leave-management',
            subtitle: 'Submit and approve requests',
          ),
          SidebarItem(
            id: 'leaveBalance',
            svgPath: Assets.icons.leaveManagement.emptyLeave.path,
            labelKey: 'leaveBalance',
            route: '/leave-management',
            subtitle: 'Employee leave balances',
          ),
          SidebarItem(
            id: 'myLeaveBalance',
            svgPath: Assets.icons.leaveManagement.myLeave.path,
            labelKey: 'myLeaveBalance',
            route: '/leave-management',
            subtitle: 'Personal leave overview',
          ),
          SidebarItem(
            id: 'teamLeaveRisk',
            svgPath: Assets.icons.leaveManagement.teamLevel.path,
            labelKey: 'teamLeaveRisk',
            route: '/leave-management',
            subtitle: 'Team absence risk analysis',
          ),
          SidebarItem(
            id: 'leavePolicies',
            svgPath: Assets.icons.leaveManagement.leavePolicy.path,
            labelKey: 'leavePolicies',
            route: '/leave-management',
            subtitle: 'Kuwait Labor Law policies',
          ),
          SidebarItem(
            id: 'policyConfiguration',
            svgPath: Assets.icons.leaveManagement.policyConfiguration.path,
            labelKey: 'policyConfiguration',
            route: '/leave-management',
            subtitle: 'Configure leave eligibility',
          ),
          SidebarItem(
            id: 'forfeitPolicy',
            svgPath: Assets.icons.leaveManagement.forfeitPolicy.path,
            labelKey: 'forfeitPolicy',
            route: '/leave-management',
            subtitle: 'Leave forfeit rules',
          ),
          SidebarItem(
            id: 'forfeitProcessing',
            svgPath: Assets.icons.leaveManagement.forfeitProcessing.path,
            labelKey: 'forfeitProcessing',
            route: '/leave-management',
            subtitle: 'Process leave forfeits',
          ),
          SidebarItem(
            id: 'forfeitReports',
            svgPath: Assets.icons.leaveManagement.forfeitReports.path,
            labelKey: 'forfeitReports',
            route: '/leave-management',
            subtitle: 'Forfeit analytics',
          ),
          SidebarItem(
            id: 'leaveCalendar',
            svgPath: Assets.icons.leaveManagement.leaveCalendar.path,
            labelKey: 'leaveCalendar',
            route: '/leave-management',
            subtitle: 'Team absence calendar',
          ),
        ],
      ),
      SidebarItem(
        id: 'attendance',
        svgPath: Assets.icons.attendanceIcon.path,
        labelKey: 'attendance',
        route: '/attendance',
      ),
      SidebarItem(
        id: 'timesheet',
        svgPath: Assets.icons.attendanceIcon.path,
        labelKey: 'timesheet',
        route: '/timesheet',
      ),
      SidebarItem(id: 'payroll', svgPath: Assets.icons.payrollIcon.path, labelKey: 'payroll', route: '/payroll'),
      SidebarItem(
        id: 'compliance',
        svgPath: Assets.icons.complianceIcon.path,
        labelKey: 'compliance',
        route: '/compliance',
      ),
      SidebarItem(
        id: 'eosCalculator',
        svgPath: Assets.icons.eosCalculatorIcon.path,
        labelKey: 'eosCalculator',
        route: '/eos-calculator',
      ),
      SidebarItem(id: 'reports', svgPath: Assets.icons.reportsIcon.path, labelKey: 'reports', route: '/reports'),
      SidebarItem(
        id: 'governmentForms',
        svgPath: Assets.icons.governmentFormsIcon.path,
        labelKey: 'governmentForms',
        route: '/government-forms',
      ),
      SidebarItem(
        id: 'deiDashboard',
        svgPath: Assets.icons.deiDashboardIcon.path,
        labelKey: 'deiDashboard',
        route: '/dei-dashboard',
      ),
      SidebarItem(
        id: 'hrOperations',
        svgPath: Assets.icons.hrOperationsIcon.path,
        labelKey: 'hrOperations',
        route: '/hr-operations',
      ),
      SidebarItem(
        id: 'settingsConfig',
        svgPath: Assets.icons.settingsIcon.path,
        labelKey: 'settingsConfig',
        route: '/settings',
      ),
    ]);
  }

  static double getChildItemFontSize(String key) {
    switch (key) {
      case 'overview':
        return 15.1;
      case 'analytics':
      case 'manageComponentValues':
      case 'department':
      case 'manageEmployees':
      case 'employeeList':
      case 'addEmployee':
      case 'employeeActions':
      case 'positions':
      case 'leaveManagement':
      case 'attendance':
      case 'timesheet':
      case 'payroll':
      case 'reports':
      case 'settingsConfig':
        return 15.3;
      case 'quickActions':
      case 'company':
      case 'division':
      case 'section':
      case 'workforcePlanning':
      case 'contracts':
      case 'compliance':
      case 'eosCalculator':
      case 'governmentForms':
      case 'deiDashboard':
      case 'hrOperations':
        return 15.4;
      case 'orgStructure':
        return 15.5;
      case 'manageEnterpriseStructure':
        return 15.3;
      default:
        return 15.4;
    }
  }

  static String getLocalizedLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'appTitle':
        return localizations.appTitle;
      case 'hrManagement':
        return 'HR Management';
      case 'dashboard':
        return localizations.dashboard;
      case 'overview':
        return 'Overview';
      case 'analytics':
        return 'Analytics';
      case 'quickActions':
        return localizations.quickActions;
      case 'moduleCatalogue':
        return localizations.moduleCatalogue;
      case 'productIntro':
        return localizations.productIntroduction;
      case 'enterpriseStructure':
        return localizations.enterpriseStructure;
      case 'manageEnterpriseStructure':
        return 'Manage Enterprise\nStructure';
      case 'manageComponentValues':
        return localizations.manageComponentValues;
      case 'company':
        return 'Company';
      case 'division':
        return 'Division';
      case 'businessUnit':
        return 'Business Unit';
      case 'department':
        return 'Department';
      case 'section':
        return 'Section';
      case 'workforceStructure':
        return localizations.workforceStructure;
      case 'timeManagement':
        return localizations.timeManagement;
      case 'shifts':
        return 'Shifts';
      case 'workPatterns':
        return 'Work Patterns';
      case 'workSchedules':
        return 'Work Schedules';
      case 'scheduleAssignments':
        return 'Schedule Assignments';
      case 'viewCalendar':
        return 'View Calendar';
      case 'publicHolidays':
        return 'Public Holidays';
      case 'employees':
        return localizations.employees;
      case 'manageEmployees':
        return 'Manage Employees';
      case 'employeeList':
        return 'Employee List';
      case 'addEmployee':
        return 'Add Employee';
      case 'employeeActions':
        return 'Employee Actions';
      case 'orgStructure':
        return 'Org Structure';
      case 'workforcePlanning':
        return 'Workforce Planning';
      case 'positions':
        return 'Positions';
      case 'contracts':
        return 'Contracts';
      case 'leaveManagement':
        return localizations.leaveManagement;
      case 'leaveRequests':
        return localizations.leaveRequests;
      case 'leaveBalance':
        return localizations.leaveBalance;
      case 'myLeaveBalance':
        return localizations.myLeaveBalance;
      case 'teamLeaveRisk':
        return localizations.teamLeaveRisk;
      case 'leavePolicies':
        return localizations.leavePolicies;
      case 'policyConfiguration':
        return localizations.policyConfiguration;
      case 'forfeitPolicy':
        return localizations.forfeitPolicy;
      case 'forfeitProcessing':
        return localizations.forfeitProcessing;
      case 'forfeitReports':
        return localizations.forfeitReports;
      case 'leaveCalendar':
        return localizations.leaveCalendar;
      case 'attendance':
        return localizations.attendance;
      case 'timesheet':
        return 'Time Sheets';
      case 'payroll':
        return localizations.payroll;
      case 'compliance':
        return localizations.compliance;
      case 'eosCalculator':
        return localizations.eosCalculator;
      case 'reports':
        return localizations.reports;
      case 'governmentForms':
        return localizations.governmentForms;
      case 'deiDashboard':
        return localizations.deiDashboard;
      case 'hrOperations':
        return localizations.hrOperations;
      case 'settingsConfig':
        return '${localizations.settings} &\nConfigurations';
      case 'kuwaitLaborLaw':
        return 'Kuwait Labor Law';
      case 'fullyCompliant':
        return 'Fully Compliant System';
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
        return key;
    }
  }
}
