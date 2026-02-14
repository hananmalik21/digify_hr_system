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
  static const String enterpriseStructureComponentValues = '$enterpriseStructure/component-values';
  static const String enterpriseStructureCompany = '$enterpriseStructure/company';
  static const String enterpriseStructureDivision = '$enterpriseStructure/division';
  static const String enterpriseStructureBusinessUnit = '$enterpriseStructure/business-unit';
  static const String enterpriseStructureDepartment = '$enterpriseStructure/department';
  static const String enterpriseStructureSection = '$enterpriseStructure/section';

  // Workforce Structure routes
  static const String workforceStructure = '/workforce-structure';

  // Time Management routes
  static const String timeManagement = '/time-management';

  // Employees routes
  static const String employees = '/employees';
  static const String employeesList = '$employees/list';
  static const String employeesAdd = '$employees/add';
  static const String employeesActions = '$employees/actions';
  static const String employeesOrgStructure = '$employees/org-structure';
  static const String employeesWorkforcePlanning = '$employees/workforce-planning';
  static const String employeesPositions = '$employees/positions';
  static const String employeesContracts = '$employees/contracts';
  static const String employeeDetail = '$employees/detail';

  // Other routes
  static const String leaveManagement = '/leave-management';
  static const String leaveManagementLeaveRequests = '$leaveManagement/leave-requests';
  static const String leaveManagementEmployeeLeaveHistorySegment = 'employee-leave-history';
  static const String leaveManagementEmployeeLeaveHistory =
      '$leaveManagement/$leaveManagementEmployeeLeaveHistorySegment';
  static const String leaveManagementLeaveBalance = '$leaveManagement/leave-balance';
  static const String leaveManagementMyLeaveBalance = '$leaveManagement/my-leave-balance';
  static const String attendance = '/attendance';
  static const String timesheet = '/timesheet';
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
