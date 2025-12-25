import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';

class SidebarConfig {
  static List<SidebarItem> getMenuItems() {
    return [
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
            svgPath: Assets
                .icons
                .businessUnitIcon
                .path, // Replaced with what was in code
            labelKey: 'positions',
            route: '/workforce-structure/positions',
          ),
          SidebarItem(
            id: 'jobFamilies',
            svgPath: Assets
                .icons
                .departmentIcon
                .path, // Replaced with what was in code
            labelKey: 'jobFamilies',
            route: '/workforce-structure/job-families',
          ),
          SidebarItem(
            id: 'jobLevels',
            svgPath: Assets
                .icons
                .positionsIcon
                .path, // Replaced with what was in code
            labelKey: 'jobLevels',
            route: '/workforce-structure/job-levels',
          ),
          SidebarItem(
            id: 'gradeStructure',
            svgPath: Assets
                .icons
                .settingsIcon
                .path, // Replaced with what was in code
            labelKey: 'gradeStructure',
            route: '/workforce-structure/grade-structure',
          ),
          SidebarItem(
            id: 'reportingStructure',
            svgPath:
                Assets.icons.companyIcon.path, // Replaced with what was in code
            labelKey: 'reportingStructure',
            route: '/workforce-structure/reporting-structure',
          ),
          SidebarItem(
            id: 'positionTree',
            svgPath: Assets
                .icons
                .departmentIcon
                .path, // Replaced with what was in code
            labelKey: 'positionTree',
            route: '/workforce-structure/position-tree',
          ),
        ],
      ),
      SidebarItem(
        id: 'timeManagement',
        svgPath: Assets.icons.timeManagementIcon.path,
        labelKey: 'timeManagement',
        route: '/time-management',
      ),
      SidebarItem(
        id: 'employees',
        svgPath: Assets.icons.employeesIcon.path,
        labelKey: 'employees',
        children: [
          SidebarItem(
            id: 'employeeList',
            svgPath: Assets.icons.employeeListIcon.path,
            labelKey: 'employeeList',
            route: '/employees/list',
          ),
          SidebarItem(
            id: 'addEmployee',
            svgPath: Assets.icons.addEmployeeIcon.path,
            labelKey: 'addEmployee',
            route: '/employees/add',
          ),
          SidebarItem(
            id: 'employeeActions',
            svgPath: Assets.icons.employeeActionsIcon.path,
            labelKey: 'employeeActions',
            route: '/employees/actions',
          ),
          SidebarItem(
            id: 'orgStructure',
            svgPath: Assets.icons.companyIcon.path,
            labelKey: 'orgStructure',
            route: '/employees/org-structure',
          ),
          SidebarItem(
            id: 'workforcePlanning',
            svgPath: Assets.icons.workforcePlanningIcon.path,
            labelKey: 'workforcePlanning',
            route: '/employees/workforce-planning',
          ),
          SidebarItem(
            id: 'positions',
            svgPath: Assets.icons.positionsIcon.path,
            labelKey: 'positions',
            route: '/employees/positions',
          ),
          SidebarItem(
            id: 'contracts',
            svgPath: Assets.icons.contractsIcon.path,
            labelKey: 'contracts',
            route: '/employees/contracts',
          ),
        ],
      ),
      SidebarItem(
        id: 'leaveManagement',
        svgPath: Assets.icons.leaveManagementIcon.path,
        labelKey: 'leaveManagement',
        route: '/leave-management',
      ),
      SidebarItem(
        id: 'attendance',
        svgPath: Assets.icons.attendanceIcon.path,
        labelKey: 'attendance',
        route: '/attendance',
      ),
      SidebarItem(
        id: 'payroll',
        svgPath: Assets.icons.payrollIcon.path,
        labelKey: 'payroll',
        route: '/payroll',
      ),
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
      SidebarItem(
        id: 'reports',
        svgPath: Assets.icons.reportsIcon.path,
        labelKey: 'reports',
        route: '/reports',
      ),
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
    ];
  }

  static double getChildItemFontSize(String key) {
    switch (key) {
      case 'overview':
        return 15.1;
      case 'analytics':
      case 'manageComponentValues':
      case 'department':
      case 'employeeList':
      case 'addEmployee':
      case 'employeeActions':
      case 'positions':
      case 'leaveManagement':
      case 'attendance':
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
      case 'employees':
        return localizations.employees;
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
      case 'attendance':
        return localizations.attendance;
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
