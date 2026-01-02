/// Centralized route paths for the entire application
/// All route paths should be defined here to maintain consistency
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String login = '/login';
  static const String signup = '/signup';

  // Dashboard routes
  static const String dashboard = '/dashboard';
  static const String dashboardOverview = '$dashboard/overview';
  static const String dashboardAnalytics = '$dashboard/analytics';
  static const String dashboardQuickActions = '$dashboard/quick-actions';

  // Module Catalogue
  static const String moduleCatalogue = '/module-catalogue';

  // Product Intro
  static const String productIntro = '/product-intro';

  // Enterprise Structure routes
  static const String enterpriseStructure = '/enterprise-structure';
  static const String enterpriseStructureManage = '$enterpriseStructure/manage';
  static const String enterpriseStructureComponentValues =
      '$enterpriseStructure/component-values';
  static const String enterpriseStructureCompany =
      '$enterpriseStructure/company';
  static const String enterpriseStructureDivision =
      '$enterpriseStructure/division';
  static const String enterpriseStructureBusinessUnit =
      '$enterpriseStructure/business-unit';
  static const String enterpriseStructureDepartment =
      '$enterpriseStructure/department';
  static const String enterpriseStructureSection =
      '$enterpriseStructure/section';

  // Workforce Structure routes
  static const String workforceStructure = '/workforce-structure';
  static const String workforceStructurePositions =
      '$workforceStructure/positions';
  static const String workforceStructureJobFamilies =
      '$workforceStructure/job-families';
  static const String workforceStructureJobLevels =
      '$workforceStructure/job-levels';
  static const String workforceStructureGradeStructure =
      '$workforceStructure/grade-structure';
  static const String workforceStructureReportingStructure =
      '$workforceStructure/reporting-structure';
  static const String workforceStructurePositionTree =
      '$workforceStructure/position-tree';

  // Time Management routes
  static const String timeManagement = '/time-management';
  static const String timeManagementShifts = '$timeManagement/shifts';
  static const String timeManagementWorkPatterns =
      '$timeManagement/work-patterns';
  static const String timeManagementWorkSchedules =
      '$timeManagement/work-schedules';
  static const String timeManagementScheduleAssignments =
      '$timeManagement/schedule-assignments';
  static const String timeManagementViewCalendar =
      '$timeManagement/view-calendar';
  static const String timeManagementPublicHolidays =
      '$timeManagement/public-holidays';

  // Employees routes
  static const String employees = '/employees';
  static const String employeesList = '$employees/list';
  static const String employeesAdd = '$employees/add';
  static const String employeesActions = '$employees/actions';
  static const String employeesOrgStructure = '$employees/org-structure';
  static const String employeesWorkforcePlanning =
      '$employees/workforce-planning';
  static const String employeesPositions = '$employees/positions';
  static const String employeesContracts = '$employees/contracts';

  // Other routes
  static const String leaveManagement = '/leave-management';
  static const String attendance = '/attendance';
  static const String payroll = '/payroll';
  static const String compliance = '/compliance';
  static const String eosCalculator = '/eos-calculator';
  static const String reports = '/reports';
  static const String governmentForms = '/government-forms';
  static const String deiDashboard = '/dei-dashboard';
  static const String hrOperations = '/hr-operations';
  static const String settings = '/settings';
  static const String home = '/home';
}
