// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Digify ERP';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get phoneHint => 'Enter your phone number';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get signupSuccess => 'Sign up successful!';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get home => 'Home';

  @override
  String get enterpriseStructure => 'Enterprise Structure';

  @override
  String get generalLedger => 'General Ledger';

  @override
  String get chartOfAccounts => 'Chart of Accounts';

  @override
  String get journalEntries => 'Journal Entries';

  @override
  String get accountBalances => 'Account Balances';

  @override
  String get intercompanyAccounting => 'Intercompany Accounting';

  @override
  String get budgetManagement => 'Budget Management';

  @override
  String get financialReportSets => 'Financial Report Sets';

  @override
  String get accountsPayable => 'Accounts Payable';

  @override
  String get accountsReceivable => 'Accounts Receivable';

  @override
  String get cashManagement => 'Cash Management';

  @override
  String get fixedAssets => 'Fixed Assets';

  @override
  String get treasury => 'Treasury';

  @override
  String get expenseManagement => 'Expense Management';

  @override
  String get financialReporting => 'Financial Reporting';

  @override
  String get periodClose => 'Period Close';

  @override
  String get workflowApprovals => 'Workflow Approvals';

  @override
  String get securityConsole => 'Security Console';

  @override
  String get securityDashboard => 'Security Dashboard';

  @override
  String get userAccounts => 'User Accounts';

  @override
  String get userAccountsSubtitle => 'Manage user accounts and permissions';

  @override
  String get userRoleAssignment => 'User Role Assignment';

  @override
  String get roleManagement => 'Role Management';

  @override
  String get roles => 'Roles';

  @override
  String get roleHierarchy => 'Role Hierarchy';

  @override
  String get roleTemplates => 'Role Templates';

  @override
  String get dataSecurity => 'Data Security';

  @override
  String get securityPolicies => 'Security Policies';

  @override
  String get dataAccessSets => 'Data Access Sets';

  @override
  String get securityProfiles => 'Security Profiles';

  @override
  String get functionPrivileges => 'Function Privileges';

  @override
  String get dutyRoles => 'Duty Roles';

  @override
  String get jobRoles => 'Job Roles';

  @override
  String get auditCompliance => 'Audit & Compliance';

  @override
  String get auditLogs => 'Audit Logs';

  @override
  String get loginHistory => 'Login History';

  @override
  String get accessReports => 'Access Reports';

  @override
  String get complianceReports => 'Compliance Reports';

  @override
  String get sessionManagement => 'Session Management';

  @override
  String get securityReports => 'Security Reports';

  @override
  String get dataSecurityPrivacy => 'Data Security & Privacy';

  @override
  String get securityReportsAnalytics => 'Security Reports & Analytics';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get securityOverview => 'Security Overview';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get activeUsers => 'Active Users';

  @override
  String get inactiveUsers => 'Inactive Users';

  @override
  String get pendingApprovals => 'Pending Approvals';

  @override
  String get totalRoles => 'Total Roles';

  @override
  String get activeRoles => 'Active Roles';

  @override
  String get customRoles => 'Custom Roles';

  @override
  String get standardRoles => 'Standard Roles';

  @override
  String get totalPrivileges => 'Total Privileges';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get roleUsage => 'Role Usage';

  @override
  String get modules => 'Modules';

  @override
  String get recentSecurityAlerts => 'Recent Security Alerts';

  @override
  String get failedLoginAttempts => 'Failed Login Attempts';

  @override
  String get unauthorizedAccess => 'Unauthorized Access Attempt';

  @override
  String get passwordExpiringUsers => 'Password Expiring for Multiple Users';

  @override
  String get unusualActivity => 'Unusual Activity Detected';

  @override
  String get investigateAll => 'Investigate All';

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get userCreated => 'User account created';

  @override
  String get roleModified => 'Role permissions modified';

  @override
  String get policyUpdated => 'Security policy updated';

  @override
  String get privilegesRevoked => 'Privileges revoked';

  @override
  String get viewAll => 'View All';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get createUser => 'Create User';

  @override
  String get assignRole => 'Assign Role';

  @override
  String get reviewAccess => 'Review Access';

  @override
  String get generateReport => 'Generate Report';

  @override
  String get systemComplianceStatus => 'System Compliance Status';

  @override
  String get userAuthentication => 'User Authentication';

  @override
  String get dataEncryption => 'Data Encryption';

  @override
  String get accessControl => 'Access Control';

  @override
  String get auditLogging => 'Audit Logging';

  @override
  String get activeSessions => 'Active Sessions';

  @override
  String get pendingReviews => 'Pending Reviews';

  @override
  String get criticalAlerts => 'Critical Alerts';

  @override
  String get searchAccounts => 'Search accounts...';

  @override
  String get allTypes => 'All Types';

  @override
  String get allStatus => 'All Status';

  @override
  String get moreFilters => 'More Filters';

  @override
  String get administrator => 'Administrator';

  @override
  String get standardUser => 'Standard User';

  @override
  String get financeUser => 'Finance User';

  @override
  String get manager => 'Manager';

  @override
  String get active2FA => 'Active (2FA)';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get view => 'View';

  @override
  String get edit => 'Edit';

  @override
  String get refresh => 'Refresh';

  @override
  String get lock => 'Lock';

  @override
  String get createAccount => 'Create Account';

  @override
  String showingResults(int count, int total) {
    return 'Showing $count of $total accounts';
  }

  @override
  String get accountDetails => 'Account Details';

  @override
  String get userInformation => 'User Information';

  @override
  String get userID => 'User ID';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get department => 'Department';

  @override
  String get position => 'Position';

  @override
  String get accountStatus => 'Account Status';

  @override
  String get mfaStatus => 'MFA Status';

  @override
  String get securityInformation => 'Security Information';

  @override
  String get assignedRoles => 'Assigned Roles';

  @override
  String get lastLogin => 'Last Login';

  @override
  String get accountCreated => 'Account Created';

  @override
  String get passwordLastChanged => 'Password Last Changed';

  @override
  String get failedAttempts => 'Failed Attempts';

  @override
  String get sessionHistory => 'Session History (Last 7 days)';

  @override
  String get date => 'Date';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get device => 'Device';

  @override
  String get location => 'Location';

  @override
  String get duration => 'Duration';

  @override
  String get close => 'Close';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get manageRoles => 'Manage Roles';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get role => 'Role';

  @override
  String get refreshUser => 'Refresh User';

  @override
  String get manageUserRoles => 'Manage User Roles';

  @override
  String get loggedInUser => 'Logged In User';

  @override
  String rolesLoadedSuccessfully(int count) {
    return '$count roles loaded successfully';
  }

  @override
  String get currentlyAssignedRoles => 'Currently Assigned Roles';

  @override
  String get availableRolesToAssign => 'Available Roles to Assign';

  @override
  String get searchRoles => 'Search roles...';

  @override
  String get assignSelected => 'Assign Selected';

  @override
  String get removeSelected => 'Remove Selected';

  @override
  String get noRolesAssigned => 'No roles assigned';

  @override
  String get noRolesAvailable => 'No available roles';

  @override
  String get rolesAssignedLabel => 'Roles Assigned';

  @override
  String get rolesAvailableLabel => 'Roles Available';

  @override
  String get roleAssignmentHistory => 'Role Assignment History';

  @override
  String get assignedBy => 'Assigned By';

  @override
  String get assignedOn => 'Assigned On';

  @override
  String get status => 'Status';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveUpdates => 'Save Updates';

  @override
  String get unsavedChanges => 'Unsaved Changes';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get userRoleAssignmentSubtitle =>
      'Assign and manage security roles for users';

  @override
  String get usersWithRoles => 'Users with Roles';

  @override
  String get avgRolesPerUser => 'Avg Roles/User';

  @override
  String get availableRoles => 'Available Roles';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get totalAssignments => 'Total Assignments';

  @override
  String get rolesInUse => 'Roles in Use';

  @override
  String get usersWithMultipleRoles => 'Users with Multiple Roles';

  @override
  String get username => 'Username';

  @override
  String get currentRoles => 'Current Roles';

  @override
  String get actions => 'Actions';

  @override
  String get roleManagementSubtitle =>
      'Manage roles, permissions, and access levels';

  @override
  String get dutyRolesOnly => 'Duty Roles';

  @override
  String get standard => 'Standard';

  @override
  String get custom => 'Custom';

  @override
  String get allTypesFilter => 'All Types';

  @override
  String get allStatusFilter => 'All Status';

  @override
  String get searchRolesPlaceholder => 'Search roles by name or code...';

  @override
  String get roleType => 'Role Type';

  @override
  String usersAssigned(int count) {
    return 'Users Assigned ($count)';
  }

  @override
  String get privileges => 'Privileges';

  @override
  String get createdOn => 'Created On';

  @override
  String get createRole => 'Create Role';

  @override
  String get createNewRole => 'Create New Role';

  @override
  String get editRole => 'Edit Role';

  @override
  String get roleInformation => 'Role Information';

  @override
  String get roleName => 'Role Name';

  @override
  String get enterRoleName => 'Enter role name';

  @override
  String get roleCode => 'Role Code';

  @override
  String get enterRoleCode => 'Enter role code (e.g., FIN_MGR_001)';

  @override
  String get roleDescription => 'Role Description';

  @override
  String get enterRoleDescription => 'Enter role description';

  @override
  String get roleConfiguration => 'Role Configuration';

  @override
  String get selectRoleType => 'Select Role Type';

  @override
  String get jobRole => 'Job Role';

  @override
  String get dutyRole => 'Duty Role';

  @override
  String get effectiveDates => 'Effective Dates';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get setActiveStatus => 'Set Active Status';

  @override
  String get setStatus => 'Set Status';

  @override
  String get privilegesAndAccess => 'Privileges & Access';

  @override
  String get functionSecurity => 'Function Security';

  @override
  String get function => 'Function';

  @override
  String get accessLevel => 'Access Level';

  @override
  String get addPrivilege => 'Add Privilege';

  @override
  String get dataAccessSet => 'Data Access Set';

  @override
  String get assignDataSets => 'Assign Data Sets';

  @override
  String get roleCreatedSuccessfully => 'Role created successfully';

  @override
  String get roleUpdatedSuccessfully => 'Role updated successfully';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get roleHierarchySubtitle =>
      'View and manage role hierarchy structure';

  @override
  String get totalNodes => 'Total Nodes';

  @override
  String get maxDepth => 'Max Depth';

  @override
  String get parentRoles => 'Parent Roles';

  @override
  String get parentRole => 'Parent Role';

  @override
  String get selectType => 'Select type';

  @override
  String get childRoles => 'Child Roles';

  @override
  String get searchHierarchy => 'Search hierarchy...';

  @override
  String get expandAll => 'Expand All';

  @override
  String get collapseAll => 'Collapse All';

  @override
  String get createRootRole => 'Create Root Role';

  @override
  String get usersAssignedLabel => 'Users Assigned';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get tryAdjustingSearchCriteria => 'Try adjusting your search criteria';

  @override
  String get addRoleToHierarchy => 'Add Role to Hierarchy';

  @override
  String get selectParentRole => 'Select Parent Role (Optional)';

  @override
  String get selectParent => 'Select parent role...';

  @override
  String get noParentRole => 'No Parent (Root Level)';

  @override
  String get existingRole => 'Existing Role';

  @override
  String get selectExistingRole => 'Select existing role';

  @override
  String get newRoleName => 'New Role Name';

  @override
  String get enterNewRoleName => 'Enter new role name';

  @override
  String get roleTypeLabel => 'Role Type';

  @override
  String get addRole => 'Add Role';

  @override
  String get roleTemplatesSubtitle =>
      'Pre-configured role templates for quick setup';

  @override
  String get totalTemplates => 'Total Templates';

  @override
  String get industrySpecific => 'Industry Specific';

  @override
  String get recentlyUsed => 'Recently Used';

  @override
  String get categories => 'Categories';

  @override
  String get category => 'Category';

  @override
  String get finance => 'Finance';

  @override
  String get operations => 'Operations';

  @override
  String get hr => 'HR';

  @override
  String get it => 'IT';

  @override
  String get import => 'Import';

  @override
  String get createTemplate => 'Create Template';

  @override
  String get useTemplate => 'Use Template';

  @override
  String get includes => 'Includes';

  @override
  String privilegesCount(int count) {
    return '$count Privileges';
  }

  @override
  String dataSetsCount(int count) {
    return '$count Data Sets';
  }

  @override
  String get createNewTemplate => 'Create New Template';

  @override
  String get creatingTemplate => 'Creating Template';

  @override
  String get templateInstructions =>
      'Create a reusable role template with pre-configured permissions and access settings';

  @override
  String get templateName => 'Template Name';

  @override
  String get enterTemplateName => 'Enter template name';

  @override
  String get templateCode => 'Template Code';

  @override
  String get enterTemplateCode => 'Enter unique template code';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get templateDescription => 'Template Description';

  @override
  String get enterTemplateDescription => 'Enter template description';

  @override
  String get includedPrivileges => 'Included Privileges';

  @override
  String get selectPrivileges => 'Select Privileges';

  @override
  String selectedPrivileges(int count) {
    return '$count selected';
  }

  @override
  String get includedDataSets => 'Included Data Sets';

  @override
  String get selectDataSets => 'Select Data Sets';

  @override
  String selectedDataSets(int count) {
    return '$count selected';
  }

  @override
  String get makeDefaultTemplate => 'Make Default Template';

  @override
  String get setAsDefault => 'Set as default for this category';

  @override
  String get createTemplateButton => 'Create Template';

  @override
  String get securityPoliciesSubtitle =>
      'Configure and manage security policies';

  @override
  String get activePolicies => 'Active Policies';

  @override
  String get pendingReview => 'Pending Review';

  @override
  String get expiringSoon => 'Expiring Soon';

  @override
  String get searchPolicies => 'Search policies...';

  @override
  String get createPolicy => 'Create Policy';

  @override
  String get policyType => 'Policy Type';

  @override
  String get enforcementLevel => 'Enforcement Level';

  @override
  String get lastModified => 'Last Modified';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get createNewPolicy => 'Create New Policy';

  @override
  String get editPolicy => 'Edit Policy';

  @override
  String get creatingPolicy => 'Creating Policy';

  @override
  String get policyInstructions =>
      'Define security policies to enforce access control and compliance';

  @override
  String get policyName => 'Policy Name';

  @override
  String get enterPolicyName => 'Enter policy name';

  @override
  String get policyCode => 'Policy Code';

  @override
  String get enterPolicyCode => 'Enter policy code';

  @override
  String get policyDescription => 'Policy Description';

  @override
  String get enterPolicyDescription => 'Enter policy description';

  @override
  String get selectPolicyType => 'Select Policy Type';

  @override
  String get passwordPolicy => 'Password Policy';

  @override
  String get accessPolicy => 'Access Policy';

  @override
  String get compliancePolicy => 'Compliance Policy';

  @override
  String get selectEnforcementLevel => 'Select Enforcement Level';

  @override
  String get mandatory => 'Mandatory';

  @override
  String get recommended => 'Recommended';

  @override
  String get optional => 'Optional';

  @override
  String get enterExpiryDate => 'Enter expiry date';

  @override
  String get policyRules => 'Policy Rules';

  @override
  String get addRule => 'Add Rule';

  @override
  String get createPolicyButton => 'Create Policy';

  @override
  String get dataAccessSetsSubtitle =>
      'Manage data access sets and permissions';

  @override
  String get totalDataAccessSets => 'Total Data Access Sets';

  @override
  String get ledgerBased => 'Ledger Based';

  @override
  String get entityBased => 'Entity Based';

  @override
  String get searchDataAccessSets => 'Search data access sets...';

  @override
  String get createDataAccessSet => 'Create Data Access Set';

  @override
  String get accessScope => 'Access Scope';

  @override
  String get createNewDataAccessSet => 'Create New Data Access Set';

  @override
  String get creatingDataAccessSet => 'Creating Data Access Set';

  @override
  String get dataAccessSetInstructions =>
      'Define data access boundaries for controlling which data users can view and modify';

  @override
  String get setName => 'Set Name';

  @override
  String get enterDataAccessSetName => 'Enter data access set name';

  @override
  String get setCode => 'Set Code';

  @override
  String get enterSetCode => 'Enter set code';

  @override
  String get accessType => 'Access Type';

  @override
  String get dataAccessConfiguration => 'Data Access Configuration';

  @override
  String get accessCriteriaChooseOne => 'Access Criteria (Choose One)';

  @override
  String get selectAccessCriteria => 'Select access criteria';

  @override
  String ledgersSelected(int count) {
    return '$count Ledgers Selected';
  }

  @override
  String get noLedgersFound => 'No ledgers found';

  @override
  String legalEntitiesSelected(int count) {
    return '$count Legal Entities Selected';
  }

  @override
  String get noLegalEntitiesFound => 'No legal entities found';

  @override
  String get createSet => 'Create Set';

  @override
  String get editDataAccessSet => 'Edit Data Access Set';

  @override
  String get updateSet => 'Update Set';

  @override
  String get enterDescription => 'Enter description (optional)';

  @override
  String get noDataAccessSetsFound => 'No data access sets found';

  @override
  String get tryAdjustingFilters =>
      'Try adjusting your filters or search criteria';

  @override
  String get noPoliciesFound => 'No policies found';

  @override
  String get noTemplatesFound => 'No templates found';

  @override
  String get noRolesFound => 'No roles found';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get noPrivilegesFound => 'No privileges found';

  @override
  String get functionPrivilegesSubtitle =>
      'Manage function-level security privileges';

  @override
  String get createPrivilege => 'Create Privilege';

  @override
  String get searchPrivileges => 'Search privileges...';

  @override
  String get all => 'All';

  @override
  String usedInRolesCount(int count) {
    return 'Used in $count roles';
  }

  @override
  String get functionArea => 'Function';

  @override
  String get actionType => 'Operation';

  @override
  String get selectActionType => 'Select Operation';

  @override
  String get selectStatus => 'Select Status';

  @override
  String get createPrivilegeTitle => 'Create Function Privilege';

  @override
  String get editPrivilegeTitle => 'Edit Function Privilege';

  @override
  String get privilegeName => 'Privilege Name';

  @override
  String get enterPrivilegeName => 'Enter privilege name';

  @override
  String get privilegeCode => 'Privilege Code';

  @override
  String get enterPrivilegeCode => 'Enter privilege code';

  @override
  String get privilegeDescription => 'Description';

  @override
  String get selectModule => 'Select Module';

  @override
  String get privilegeCreatedSuccessfully => 'Privilege created successfully';

  @override
  String get privilegeUpdatedSuccessfully => 'Privilege updated successfully';

  @override
  String get module => 'Module';

  @override
  String get privilege => 'Privilege';

  @override
  String get rootRoles => 'Root Roles';

  @override
  String get hierarchyStructure => 'Hierarchy Structure';

  @override
  String get saveRole => 'Save Role';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get pleaseEnterRoleName => 'Please enter role name';

  @override
  String get pleaseEnterRoleCode => 'Please enter role code';

  @override
  String get description => 'Description';

  @override
  String get priority => 'Priority';

  @override
  String get activeRole => 'Active Role';

  @override
  String get assignPrivileges => 'Assign Privileges';

  @override
  String get functions => 'Functions';

  @override
  String get securityIncidents => 'Security Incidents';

  @override
  String get securityAlerts => 'Security Alerts';

  @override
  String get recentSecurityActivities => 'Recent Security Activities';

  @override
  String get configureDataSecurity => 'Configure Data Security';

  @override
  String get viewAuditLogs => 'View Audit Logs';

  @override
  String get passwordPolicyCompliance => 'Password Policy Compliance';

  @override
  String get multiFactorAuthentication => 'Multi-Factor Authentication';

  @override
  String get activeUserReview => 'Active User Review';

  @override
  String get segregationOfDuties => 'Segregation of Duties';

  @override
  String get complianceStatus => 'Compliance Status';

  @override
  String get passwordsExpiring => 'Passwords Expiring';

  @override
  String get complianceScore => 'Compliance Score';

  @override
  String get tasksEvents => 'Tasks & Events';

  @override
  String get attendanceLeaves => 'Attendance & Leaves';

  @override
  String get myTasks => 'MY TASKS';

  @override
  String get upcomingEvents => 'UPCOMING EVENTS';

  @override
  String get reviewLeaveRequests => 'Review pending leave requests';

  @override
  String get dueToday => 'Due today';

  @override
  String get processMonthlyPayroll => 'Process monthly payroll';

  @override
  String get dueIn3Days => 'Due in 3 days';

  @override
  String get updateEmployeeRecords => 'Update employee records';

  @override
  String get completed => 'Completed';

  @override
  String get teamMeeting => 'Team Meeting';

  @override
  String get payrollProcessing => 'Payroll Processing';

  @override
  String get allDay => 'All-day';

  @override
  String get viewAllTasksEvents => 'View All Tasks & Events';

  @override
  String get todaysAttendance => 'TODAY\'S ATTENDANCE';

  @override
  String get checkInTime => 'Check In Time';

  @override
  String get statusOnTime => 'On Time';

  @override
  String get myUpcomingLeaves => 'MY UPCOMING LEAVES';

  @override
  String get annualLeave => 'Annual Leave';

  @override
  String get leaveDates => 'Dec 25 - Dec 30, 2024';

  @override
  String get approved => 'Approved';

  @override
  String get teamOnLeaveToday => 'TEAM ON LEAVE TODAY';

  @override
  String get ahmadHassan => 'Ahmad Hassan';

  @override
  String get sickLeave => 'Sick Leave';

  @override
  String get mohammedKhan => 'Mohammed Khan';

  @override
  String get emergencyLeave => 'Emergency Leave';

  @override
  String get viewFullCalendar => 'View Full Calendar';

  @override
  String get adminUser => 'Admin User';

  @override
  String get welcomeAdmin => 'Welcome, Admin User';

  @override
  String get timeManagement => 'Time Management';

  @override
  String get leaveManagement => 'Leave Management';

  @override
  String get workforceStructure => 'Workforce Structure';

  @override
  String get eosCalculator => 'EOS Calculator';

  @override
  String get governmentForms => 'Government Forms';

  @override
  String get hrOperations => 'HR Operations';

  @override
  String get deiDashboard => 'DEI Dashboard';

  @override
  String get moduleCatalogue => 'Module Catalogue';

  @override
  String get productIntroduction => 'Product Introduction';

  @override
  String get employees => 'Employees';

  @override
  String get attendance => 'Attendance';

  @override
  String get payroll => 'Payroll';

  @override
  String get compliance => 'Compliance';

  @override
  String get reports => 'Reports';

  @override
  String get manageEnterpriseStructure => 'Manage Enterprise Structure';

  @override
  String get configureManageHierarchy =>
      'Configure and manage your organizational hierarchy structures';

  @override
  String get configureManageHierarchyAr =>
      'إدارة وتكوين هياكل التسلسل الإداري للمؤسسة';

  @override
  String get currentlyActiveStructure => 'Currently Active Structure';

  @override
  String get standardKuwaitCorporateStructure =>
      'Standard Kuwait Corporate Structure';

  @override
  String get traditionalHierarchicalStructure =>
      'Traditional hierarchical structure with all five levels for comprehensive organizational management';

  @override
  String get activeLevels => 'Active Levels';

  @override
  String get components => 'Components';

  @override
  String get employeesAssigned => 'Employees Assigned';

  @override
  String get totalStructures => 'Total Structures';

  @override
  String get activeStructure => 'Active Structure';

  @override
  String get componentsInUse => 'Components in Use';

  @override
  String get structureConfigurations => 'Structure Configurations';

  @override
  String get manageDifferentConfigurations =>
      'Manage different organizational hierarchy configurations. Only one can be active at a time.';

  @override
  String get createNewStructure => 'Create New Structure';

  @override
  String get hierarchy => 'Hierarchy';

  @override
  String get levels => 'levels';

  @override
  String get created => 'Created';

  @override
  String get modified => 'Modified';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get activate => 'Activate';

  @override
  String get delete => 'Delete';

  @override
  String get notUsed => 'NOT USED';

  @override
  String get simplifiedStructure => 'Simplified Structure';

  @override
  String get streamlinedStructure =>
      'Streamlined structure for smaller organizations - Company, Division, and Department only';

  @override
  String get flatOrganizationStructure => 'Flat Organization Structure';

  @override
  String get minimalHierarchy =>
      'Minimal hierarchy for startups and agile teams - Company and Department only';

  @override
  String get currentlyActiveStructureMessage =>
      'This is the currently active structure. To activate a different structure, click the \"Activate\" button on another configuration.';

  @override
  String get company => 'Company';

  @override
  String get companies => 'Companies';

  @override
  String get division => 'Division';

  @override
  String get divisions => 'Divisions';

  @override
  String get businessUnit => 'Business Unit';

  @override
  String get businessUnits => 'Business Units';

  @override
  String get departments => 'Departments';

  @override
  String get section => 'Section';

  @override
  String get sections => 'Sections';

  @override
  String get companyCode => 'Company Code';

  @override
  String get companyNameEnglish => 'Company Name (English)';

  @override
  String get companyNameArabic => 'Company Name (Arabic)';

  @override
  String get legalNameEnglish => 'Legal Name (English)';

  @override
  String get legalNameArabic => 'Legal Name (Arabic)';

  @override
  String get industry => 'Industry';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get address => 'Address';

  @override
  String get poBox => 'P.O. Box';

  @override
  String get zipCode => 'Zip Code';

  @override
  String get website => 'Website';

  @override
  String get currency => 'Currency';

  @override
  String get fiscalYearStart => 'Fiscal Year Start (MM-DD)';

  @override
  String get phone => 'Phone';

  @override
  String get viewEnterpriseStructureConfiguration =>
      'View Enterprise Structure Configuration';

  @override
  String get reviewOrganizationalHierarchy =>
      'Review organizational hierarchy levels and sequence';

  @override
  String get structureConfigurationActive => 'Structure Configuration Active';

  @override
  String get enterpriseStructureActiveMessage =>
      'Your enterprise structure hierarchy is configured and active. You can modify the levels and order below.';

  @override
  String get configurationInstructions => 'Configuration Instructions';

  @override
  String get companyMandatoryInstruction =>
      'Company is mandatory and must be the top level - it cannot be disabled or reordered';

  @override
  String get enableDisableLevelsInstruction =>
      'Enable or disable levels based on your organizational needs';

  @override
  String get useArrowsInstruction =>
      'Use the up/down arrows to change the hierarchy sequence';

  @override
  String get orderDeterminesRelationshipsInstruction =>
      'The order determines parent-child relationships in your org structure';

  @override
  String get changesAffectComponentsInstruction =>
      'Changes will affect how components are created and displayed in the tree view';

  @override
  String get previewStructure => 'Preview Structure';

  @override
  String get saveConfiguration => 'Save Configuration';

  @override
  String get organizationalHierarchyLevels => 'Organizational Hierarchy Levels';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String levelInHierarchy(int level) {
    return '$level';
  }

  @override
  String get hierarchyPreview => 'Hierarchy Preview';

  @override
  String level(int levelNumber) {
    return '$levelNumber';
  }

  @override
  String get configurationSummary => 'Configuration Summary';

  @override
  String get totalLevels => 'Total Levels';

  @override
  String get hierarchyDepth => 'Hierarchy Depth';

  @override
  String get topLevel => 'Top Level';

  @override
  String get editEnterpriseStructureConfiguration =>
      'Edit Enterprise Structure Configuration';

  @override
  String get defineOrganizationalHierarchy =>
      'Define your organizational hierarchy levels and sequence';

  @override
  String get createEnterpriseStructureConfiguration =>
      'Create Enterprise Structure Configuration';

  @override
  String get noConfigurationFound => 'No Configuration Found';

  @override
  String get pleaseConfigureEnterpriseStructure =>
      'Please configure your enterprise structure hierarchy before creating components.';

  @override
  String get structureName => 'Structure Name';

  @override
  String get structureNamePlaceholder =>
      'e.g., Standard Corporate Structure, Simplified Structure';

  @override
  String get descriptionPlaceholder =>
      'Describe this structure configuration and when it should be used...';

  @override
  String get manageComponentValues => 'Manage Component Values';

  @override
  String get componentValuesSubtitle =>
      'Create and manage organizational components (Company, Division, Business Unit, Department, Section)';

  @override
  String get manageOrganizationalHierarchy =>
      'Manage organizational hierarchy and structure';

  @override
  String get manageOrganizationalHierarchyAr =>
      'إدارة الهيكل التنظيمي والتسلسل الإداري';

  @override
  String get structureConfiguration => 'Structure Configuration';

  @override
  String get organizationalTreeStructure => 'Organizational Tree Structure';

  @override
  String get addNewComponent => 'Add New Component';

  @override
  String get bulkUpload => 'Bulk Upload';

  @override
  String get bulkUploadTitle => 'Bulk Upload - Enterprise Structure Components';

  @override
  String get bulkUploadInstructionsTitle => 'Upload Instructions';

  @override
  String get bulkUploadInstructionDownloadTemplate =>
      'Download the template file to see the required format';

  @override
  String get bulkUploadInstructionRequiredFields =>
      'Fill in all required fields: Type, Code, Name, Name Arabic, Parent Code (if applicable)';

  @override
  String get bulkUploadInstructionOptionalFields =>
      'Optional fields: Manager ID, Cost Center, Location, Description';

  @override
  String get bulkUploadInstructionParentCode =>
      'Parent Code must match an existing component code';

  @override
  String get bulkUploadInstructionFileFormat =>
      'File format: Excel (.xlsx) or CSV (.csv)';

  @override
  String get bulkUploadInstructionRowLimit => 'Maximum 1000 rows per upload';

  @override
  String get bulkUploadStepDownloadLabel => 'Step 1: Download Template';

  @override
  String get bulkUploadDownloadTemplate => 'Download Excel Template';

  @override
  String get bulkUploadStepUploadLabel => 'Step 2: Upload Filled Template';

  @override
  String get bulkUploadDropHint =>
      'Drag and drop your file here, or click to browse';

  @override
  String get bulkUploadSupportedFormats =>
      'Supports: .xlsx, .csv (Max size: 10MB)';

  @override
  String get bulkUploadTemplatePreview => 'Template Format Preview';

  @override
  String get bulkUploadTypeHeader => 'Type*';

  @override
  String get bulkUploadCodeHeader => 'Code*';

  @override
  String get bulkUploadNameHeader => 'Name*';

  @override
  String get bulkUploadNameArabicHeader => 'Name Arabic*';

  @override
  String get bulkUploadParentCodeHeader => 'Parent Code';

  @override
  String get bulkUploadManagerIdHeader => 'Manager ID';

  @override
  String get bulkUploadLocationHeader => 'Location';

  @override
  String get bulkUploadSampleRow1Type => 'company';

  @override
  String get bulkUploadSampleRow1Code => 'COMP-001';

  @override
  String get bulkUploadSampleRow1Name => 'Main Company';

  @override
  String get bulkUploadSampleRow1NameArabic => 'الشركة الرئيسية';

  @override
  String get bulkUploadSampleRow1ParentCode => '-';

  @override
  String get bulkUploadSampleRow1ManagerId => 'EMP-001';

  @override
  String get bulkUploadSampleRow1Location => 'Kuwait City';

  @override
  String get bulkUploadSampleRow2Type => 'division';

  @override
  String get bulkUploadSampleRow2Code => 'DIV-001';

  @override
  String get bulkUploadSampleRow2Name => 'Finance Division';

  @override
  String get bulkUploadSampleRow2NameArabic => 'قسم المالية';

  @override
  String get bulkUploadSampleRow2ParentCode => 'COMP-001';

  @override
  String get bulkUploadSampleRow2ManagerId => 'EMP-010';

  @override
  String get bulkUploadSampleRow2Location => 'Kuwait City HQ';

  @override
  String get bulkUploadUploadButton => 'Upload & Process';

  @override
  String get export => 'Export';

  @override
  String get searchComponents => 'Search by name, code, or Arabic name...';

  @override
  String get componentType => 'Component Type';

  @override
  String get componentCode => 'Code';

  @override
  String get componentName => 'Name';

  @override
  String get arabicName => 'Arabic Name';

  @override
  String get parentComponent => 'Parent';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get createComponent => 'Create Component';

  @override
  String get editComponent => 'Edit Component';

  @override
  String get viewComponent => 'View Component';

  @override
  String get deleteComponent => 'Delete Component';

  @override
  String get treeView => 'Tree View';

  @override
  String get listView => 'List View';

  @override
  String get noComponentsFound => 'No components found';

  @override
  String get confirmDeleteComponent =>
      'Are you sure you want to delete this component?';

  @override
  String get componentTypeRequired => 'Component type is required';

  @override
  String get componentCodeRequired => 'Component code is required';

  @override
  String get componentNameRequired => 'Component name is required';

  @override
  String get arabicNameRequired => 'Arabic name is required';

  @override
  String get selectComponentType => 'Select component type';

  @override
  String get enterComponentCode => 'Enter component code';

  @override
  String get enterComponentName => 'Enter component name';

  @override
  String get enterArabicName => 'Enter Arabic name';

  @override
  String get selectParentComponent => 'Select parent component (optional)';

  @override
  String get selectManager => 'Select manager';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get componentCreatedSuccessfully => 'Component created successfully';

  @override
  String get componentUpdatedSuccessfully => 'Component updated successfully';

  @override
  String get componentDeletedSuccessfully => 'Component deleted successfully';

  @override
  String get bulkUploadInstructions =>
      'Upload a CSV file with component data. Download the template for the correct format.';

  @override
  String get downloadTemplate => 'Download Template';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get selectFile => 'Select File';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get uploadSuccess => 'Upload successful';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get processingUpload => 'Processing upload...';

  @override
  String get selectComponentTypePlaceholder => 'Select type...';

  @override
  String get componentDetails => 'Component Details';

  @override
  String get hierarchyRelationships => 'Hierarchy & Relationships';

  @override
  String get managementInformation => 'Management Information';

  @override
  String get auditTrail => 'Audit Trail';

  @override
  String get additionalFields => 'Additional Fields';

  @override
  String get nameEnglish => 'Name (English)';

  @override
  String get nameArabic => 'Name (Arabic)';

  @override
  String get costCenter => 'Cost Center';

  @override
  String get childComponents => 'Child Components';

  @override
  String get hierarchyPath => 'Hierarchy Path';

  @override
  String get hierarchyLevel => 'Hierarchy Level';

  @override
  String get lastUpdatedDate => 'Last Updated Date';

  @override
  String get lastUpdatedBy => 'Last Updated By';

  @override
  String get establishedDate => 'Established Date';

  @override
  String get registrationNumber => 'Registration Number';

  @override
  String get taxId => 'Tax Id';

  @override
  String get rootLevelNoParent => 'Root Level - No Parent';

  @override
  String get noDescription => 'No description provided';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get companyManagement => 'Company Management';

  @override
  String get manageCompanyInformation =>
      'Manage company information and organizational entities';

  @override
  String get addCompany => 'Add Company';

  @override
  String get totalCompanies => 'Total Companies';

  @override
  String get activeCompanies => 'Active Companies';

  @override
  String get totalEmployees => 'Total Employees';

  @override
  String get compliant => 'Compliant';

  @override
  String get searchCompaniesPlaceholder =>
      'Search by company name, code, or registration number...';

  @override
  String get editCompany => 'Edit Company';

  @override
  String get updateCompany => 'Update Company';

  @override
  String get hintCompanyCode => 'Enter company code';

  @override
  String get hintCompanyNameEnglish => 'Enter company name in English';

  @override
  String get hintCompanyNameArabic => 'أدخل اسم الشركة بالعربية';

  @override
  String get hintLegalNameEnglish => 'Enter legal name in English';

  @override
  String get hintLegalNameArabic => 'أدخل الاسم القانوني بالعربية';

  @override
  String get hintRegistrationNumber => 'Enter registration number';

  @override
  String get hintTaxId => 'Enter tax ID';

  @override
  String get hintEstablishedDate => 'DD/MM/YYYY';

  @override
  String get hintIndustry => 'Enter industry';

  @override
  String get hintCountry => 'Enter country';

  @override
  String get hintCity => 'Enter city';

  @override
  String get hintAddress => 'Enter full address';

  @override
  String get hintPoBox => 'Enter P.O. Box';

  @override
  String get hintZipCode => 'Enter zip code';

  @override
  String get hintPhone => 'Enter phone number';

  @override
  String get hintEmail => 'Enter email address';

  @override
  String get hintWebsite => 'Enter website URL';

  @override
  String get hintTotalEmployees => 'Enter total employees';

  @override
  String get hintFiscalYearStart => 'MM-DD';

  @override
  String get companyDetails => 'Company Details';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get financialAndOperational => 'Financial & Operational';

  @override
  String get established => 'Established';

  @override
  String get divisionManagement => 'Division Management';

  @override
  String get manageDivisionsSubtitle =>
      'Manage organizational divisions across companies';

  @override
  String get addDivision => 'Add Division';

  @override
  String get totalDivisions => 'Total Divisions';

  @override
  String get activeDivisions => 'Active Divisions';

  @override
  String get totalBudget => 'Total Budget';

  @override
  String get searchDivisionsPlaceholder =>
      'Search by division name, code, or head of division...';

  @override
  String get allCompanies => 'All Companies';

  @override
  String get head => 'Head';

  @override
  String get emp => 'emp';

  @override
  String get depts => 'depts';

  @override
  String get addNewDivision => 'Add New Division';

  @override
  String get editDivision => 'Edit Division';

  @override
  String get divisionCode => 'Division Code';

  @override
  String get divisionNameEnglish => 'Division Name (English)';

  @override
  String get divisionNameArabic => 'Division Name (Arabic)';

  @override
  String get headOfDivision => 'Head of Division';

  @override
  String get headEmail => 'Head Email';

  @override
  String get headPhone => 'Head Phone';

  @override
  String get businessFocus => 'Business Focus';

  @override
  String get totalDepartments => 'Total Departments';

  @override
  String get annualBudgetKwd => 'Annual Budget (KWD)';

  @override
  String get divisionDescription => 'Description';

  @override
  String get createDivision => 'Create Division';

  @override
  String get updateDivision => 'Update Division';

  @override
  String get selectCompany => 'Select Company';

  @override
  String get hintDivisionCode => 'e.g., DIV-FIN';

  @override
  String get hintDivisionNameEnglish => 'Division Name';

  @override
  String get hintDivisionNameArabic => 'اسم القسم';

  @override
  String get hintHeadOfDivision => 'Full Name';

  @override
  String get hintHeadEmail => 'email@company.com';

  @override
  String get hintHeadPhone => '+965 XXXX XXXX';

  @override
  String get hintLocation => 'Building/Floor';

  @override
  String get hintBusinessFocus => 'e.g., Financial Services';

  @override
  String get hintTotalDepartments => '0';

  @override
  String get hintAnnualBudgetKwd => '0';

  @override
  String get hintDivisionDescription =>
      'Brief description of the division\'s role and responsibilities';

  @override
  String get divisionDetails => 'Division Details';

  @override
  String get leadership => 'Leadership';

  @override
  String get organizationalMetrics => 'Organizational Metrics';

  @override
  String get annualBudget => 'Annual Budget';
}
