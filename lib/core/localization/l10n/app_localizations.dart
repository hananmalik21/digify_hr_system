import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Digify ERP'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToAccessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your HR dashboard'**
  String get signInToAccessDashboard;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo Credentials:'**
  String get demoCredentials;

  /// No description provided for @resetDemoUsers.
  ///
  /// In en, this message translates to:
  /// **'Reset Demo Users'**
  String get resetDemoUsers;

  /// No description provided for @copyrightText.
  ///
  /// In en, this message translates to:
  /// **'© 2024 Digify HR. Kuwait Labor Law Compliant.'**
  String get copyrightText;

  /// No description provided for @kuwaitLaborLawCompliant.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law Compliant'**
  String get kuwaitLaborLawCompliant;

  /// No description provided for @digifyHrTitle.
  ///
  /// In en, this message translates to:
  /// **'Digify HR'**
  String get digifyHrTitle;

  /// No description provided for @systemDescription.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Human Resource Management System with advanced security and compliance features.'**
  String get systemDescription;

  /// No description provided for @completeHrSuite.
  ///
  /// In en, this message translates to:
  /// **'Complete HR Suite'**
  String get completeHrSuite;

  /// No description provided for @completeHrSuiteDescription.
  ///
  /// In en, this message translates to:
  /// **'19 integrated modules managing all aspects of human resources'**
  String get completeHrSuiteDescription;

  /// No description provided for @advancedSecurity.
  ///
  /// In en, this message translates to:
  /// **'Advanced Security'**
  String get advancedSecurity;

  /// No description provided for @advancedSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Role-based access control with 60+ security functions'**
  String get advancedSecurityDescription;

  /// No description provided for @kuwaitCompliance.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Compliance'**
  String get kuwaitCompliance;

  /// No description provided for @kuwaitComplianceDescription.
  ///
  /// In en, this message translates to:
  /// **'Fully compliant with Kuwait Labor Law No. 6/2010'**
  String get kuwaitComplianceDescription;

  /// No description provided for @realTimeAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Real-time Analytics'**
  String get realTimeAnalytics;

  /// No description provided for @realTimeAnalyticsDescription.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive reporting and analytics dashboard'**
  String get realTimeAnalyticsDescription;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get invalidCredentials;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful!'**
  String get signupSuccess;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @enterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Structure'**
  String get enterpriseStructure;

  /// No description provided for @generalLedger.
  ///
  /// In en, this message translates to:
  /// **'General Ledger'**
  String get generalLedger;

  /// No description provided for @chartOfAccounts.
  ///
  /// In en, this message translates to:
  /// **'Chart of Accounts'**
  String get chartOfAccounts;

  /// No description provided for @journalEntries.
  ///
  /// In en, this message translates to:
  /// **'Journal Entries'**
  String get journalEntries;

  /// No description provided for @accountBalances.
  ///
  /// In en, this message translates to:
  /// **'Account Balances'**
  String get accountBalances;

  /// No description provided for @intercompanyAccounting.
  ///
  /// In en, this message translates to:
  /// **'Intercompany Accounting'**
  String get intercompanyAccounting;

  /// No description provided for @budgetManagement.
  ///
  /// In en, this message translates to:
  /// **'Budget Management'**
  String get budgetManagement;

  /// No description provided for @financialReportSets.
  ///
  /// In en, this message translates to:
  /// **'Financial Report Sets'**
  String get financialReportSets;

  /// No description provided for @accountsPayable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Payable'**
  String get accountsPayable;

  /// No description provided for @accountsReceivable.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable'**
  String get accountsReceivable;

  /// No description provided for @cashManagement.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get cashManagement;

  /// No description provided for @fixedAssets.
  ///
  /// In en, this message translates to:
  /// **'Fixed Assets'**
  String get fixedAssets;

  /// No description provided for @treasury.
  ///
  /// In en, this message translates to:
  /// **'Treasury'**
  String get treasury;

  /// No description provided for @expenseManagement.
  ///
  /// In en, this message translates to:
  /// **'Expense Management'**
  String get expenseManagement;

  /// No description provided for @financialReporting.
  ///
  /// In en, this message translates to:
  /// **'Financial Reporting'**
  String get financialReporting;

  /// No description provided for @periodClose.
  ///
  /// In en, this message translates to:
  /// **'Period Close'**
  String get periodClose;

  /// No description provided for @workflowApprovals.
  ///
  /// In en, this message translates to:
  /// **'Workflow Approvals'**
  String get workflowApprovals;

  /// No description provided for @securityConsole.
  ///
  /// In en, this message translates to:
  /// **'Security Console'**
  String get securityConsole;

  /// No description provided for @securityDashboard.
  ///
  /// In en, this message translates to:
  /// **'Security Dashboard'**
  String get securityDashboard;

  /// No description provided for @userAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get userAccounts;

  /// No description provided for @userAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage user accounts and permissions'**
  String get userAccountsSubtitle;

  /// No description provided for @userRoleAssignment.
  ///
  /// In en, this message translates to:
  /// **'User Role Assignment'**
  String get userRoleAssignment;

  /// No description provided for @roleManagement.
  ///
  /// In en, this message translates to:
  /// **'Role Management'**
  String get roleManagement;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @roleHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Role Hierarchy'**
  String get roleHierarchy;

  /// No description provided for @roleTemplates.
  ///
  /// In en, this message translates to:
  /// **'Role Templates'**
  String get roleTemplates;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @securityPolicies.
  ///
  /// In en, this message translates to:
  /// **'Security Policies'**
  String get securityPolicies;

  /// No description provided for @dataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Data Access Sets'**
  String get dataAccessSets;

  /// No description provided for @securityProfiles.
  ///
  /// In en, this message translates to:
  /// **'Security Profiles'**
  String get securityProfiles;

  /// No description provided for @functionPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Function Privileges'**
  String get functionPrivileges;

  /// No description provided for @dutyRoles.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles'**
  String get dutyRoles;

  /// No description provided for @jobRoles.
  ///
  /// In en, this message translates to:
  /// **'Job Roles'**
  String get jobRoles;

  /// No description provided for @auditCompliance.
  ///
  /// In en, this message translates to:
  /// **'Audit & Compliance'**
  String get auditCompliance;

  /// No description provided for @auditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get auditLogs;

  /// No description provided for @loginHistory.
  ///
  /// In en, this message translates to:
  /// **'Login History'**
  String get loginHistory;

  /// No description provided for @accessReports.
  ///
  /// In en, this message translates to:
  /// **'Access Reports'**
  String get accessReports;

  /// No description provided for @complianceReports.
  ///
  /// In en, this message translates to:
  /// **'Compliance Reports'**
  String get complianceReports;

  /// No description provided for @sessionManagement.
  ///
  /// In en, this message translates to:
  /// **'Session Management'**
  String get sessionManagement;

  /// No description provided for @securityReports.
  ///
  /// In en, this message translates to:
  /// **'Security Reports'**
  String get securityReports;

  /// No description provided for @dataSecurityPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data Security & Privacy'**
  String get dataSecurityPrivacy;

  /// No description provided for @securityReportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Security Reports & Analytics'**
  String get securityReportsAnalytics;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @securityOverview.
  ///
  /// In en, this message translates to:
  /// **'Security Overview'**
  String get securityOverview;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @inactiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Inactive Users'**
  String get inactiveUsers;

  /// No description provided for @pendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get pendingApprovals;

  /// No description provided for @totalRoles.
  ///
  /// In en, this message translates to:
  /// **'Total Roles'**
  String get totalRoles;

  /// No description provided for @activeRoles.
  ///
  /// In en, this message translates to:
  /// **'Active Roles'**
  String get activeRoles;

  /// No description provided for @customRoles.
  ///
  /// In en, this message translates to:
  /// **'Custom Roles'**
  String get customRoles;

  /// No description provided for @standardRoles.
  ///
  /// In en, this message translates to:
  /// **'Standard Roles'**
  String get standardRoles;

  /// No description provided for @totalPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Total Privileges'**
  String get totalPrivileges;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @roleUsage.
  ///
  /// In en, this message translates to:
  /// **'Role Usage'**
  String get roleUsage;

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @recentSecurityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Alerts'**
  String get recentSecurityAlerts;

  /// No description provided for @failedLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed Login Attempts'**
  String get failedLoginAttempts;

  /// No description provided for @unauthorizedAccess.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Access Attempt'**
  String get unauthorizedAccess;

  /// No description provided for @passwordExpiringUsers.
  ///
  /// In en, this message translates to:
  /// **'Password Expiring for Multiple Users'**
  String get passwordExpiringUsers;

  /// No description provided for @unusualActivity.
  ///
  /// In en, this message translates to:
  /// **'Unusual Activity Detected'**
  String get unusualActivity;

  /// No description provided for @investigateAll.
  ///
  /// In en, this message translates to:
  /// **'Investigate All'**
  String get investigateAll;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User account created'**
  String get userCreated;

  /// No description provided for @roleModified.
  ///
  /// In en, this message translates to:
  /// **'Role permissions modified'**
  String get roleModified;

  /// No description provided for @policyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Security policy updated'**
  String get policyUpdated;

  /// No description provided for @privilegesRevoked.
  ///
  /// In en, this message translates to:
  /// **'Privileges revoked'**
  String get privilegesRevoked;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @assignRole.
  ///
  /// In en, this message translates to:
  /// **'Assign Role'**
  String get assignRole;

  /// No description provided for @reviewAccess.
  ///
  /// In en, this message translates to:
  /// **'Review Access'**
  String get reviewAccess;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @systemComplianceStatus.
  ///
  /// In en, this message translates to:
  /// **'System Compliance Status'**
  String get systemComplianceStatus;

  /// No description provided for @userAuthentication.
  ///
  /// In en, this message translates to:
  /// **'User Authentication'**
  String get userAuthentication;

  /// No description provided for @dataEncryption.
  ///
  /// In en, this message translates to:
  /// **'Data Encryption'**
  String get dataEncryption;

  /// No description provided for @accessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get accessControl;

  /// No description provided for @auditLogging.
  ///
  /// In en, this message translates to:
  /// **'Audit Logging'**
  String get auditLogging;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get activeSessions;

  /// No description provided for @pendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get pendingReviews;

  /// No description provided for @criticalAlerts.
  ///
  /// In en, this message translates to:
  /// **'Critical Alerts'**
  String get criticalAlerts;

  /// No description provided for @searchAccounts.
  ///
  /// In en, this message translates to:
  /// **'Search accounts...'**
  String get searchAccounts;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @moreFilters.
  ///
  /// In en, this message translates to:
  /// **'More Filters'**
  String get moreFilters;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @standardUser.
  ///
  /// In en, this message translates to:
  /// **'Standard User'**
  String get standardUser;

  /// No description provided for @financeUser.
  ///
  /// In en, this message translates to:
  /// **'Finance User'**
  String get financeUser;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @active2FA.
  ///
  /// In en, this message translates to:
  /// **'Active (2FA)'**
  String get active2FA;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @showingResults.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total} accounts'**
  String showingResults(int count, int total);

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @userID.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userID;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @mfaStatus.
  ///
  /// In en, this message translates to:
  /// **'MFA Status'**
  String get mfaStatus;

  /// No description provided for @securityInformation.
  ///
  /// In en, this message translates to:
  /// **'Security Information'**
  String get securityInformation;

  /// No description provided for @assignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Assigned Roles'**
  String get assignedRoles;

  /// No description provided for @lastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get lastLogin;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get accountCreated;

  /// No description provided for @passwordLastChanged.
  ///
  /// In en, this message translates to:
  /// **'Password Last Changed'**
  String get passwordLastChanged;

  /// No description provided for @failedAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed Attempts'**
  String get failedAttempts;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History (Last 7 days)'**
  String get sessionHistory;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @manageRoles.
  ///
  /// In en, this message translates to:
  /// **'Manage Roles'**
  String get manageRoles;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users...'**
  String get searchUsers;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @refreshUser.
  ///
  /// In en, this message translates to:
  /// **'Refresh User'**
  String get refreshUser;

  /// No description provided for @manageUserRoles.
  ///
  /// In en, this message translates to:
  /// **'Manage User Roles'**
  String get manageUserRoles;

  /// No description provided for @loggedInUser.
  ///
  /// In en, this message translates to:
  /// **'Logged In User'**
  String get loggedInUser;

  /// No description provided for @rolesLoadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} roles loaded successfully'**
  String rolesLoadedSuccessfully(int count);

  /// No description provided for @currentlyAssignedRoles.
  ///
  /// In en, this message translates to:
  /// **'Currently Assigned Roles'**
  String get currentlyAssignedRoles;

  /// No description provided for @availableRolesToAssign.
  ///
  /// In en, this message translates to:
  /// **'Available Roles to Assign'**
  String get availableRolesToAssign;

  /// No description provided for @searchRoles.
  ///
  /// In en, this message translates to:
  /// **'Search roles...'**
  String get searchRoles;

  /// No description provided for @assignSelected.
  ///
  /// In en, this message translates to:
  /// **'Assign Selected'**
  String get assignSelected;

  /// No description provided for @removeSelected.
  ///
  /// In en, this message translates to:
  /// **'Remove Selected'**
  String get removeSelected;

  /// No description provided for @noRolesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No roles assigned'**
  String get noRolesAssigned;

  /// No description provided for @noRolesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No available roles'**
  String get noRolesAvailable;

  /// No description provided for @rolesAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Roles Assigned'**
  String get rolesAssignedLabel;

  /// No description provided for @rolesAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Roles Available'**
  String get rolesAvailableLabel;

  /// No description provided for @roleAssignmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Role Assignment History'**
  String get roleAssignmentHistory;

  /// No description provided for @assignedBy.
  ///
  /// In en, this message translates to:
  /// **'Assigned By'**
  String get assignedBy;

  /// No description provided for @assignedOn.
  ///
  /// In en, this message translates to:
  /// **'Assigned On'**
  String get assignedOn;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveUpdates.
  ///
  /// In en, this message translates to:
  /// **'Save Updates'**
  String get saveUpdates;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @userRoleAssignmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assign and manage security roles for users'**
  String get userRoleAssignmentSubtitle;

  /// No description provided for @usersWithRoles.
  ///
  /// In en, this message translates to:
  /// **'Users with Roles'**
  String get usersWithRoles;

  /// No description provided for @avgRolesPerUser.
  ///
  /// In en, this message translates to:
  /// **'Avg Roles/User'**
  String get avgRolesPerUser;

  /// No description provided for @availableRoles.
  ///
  /// In en, this message translates to:
  /// **'Available Roles'**
  String get availableRoles;

  /// No description provided for @refreshData.
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// No description provided for @totalAssignments.
  ///
  /// In en, this message translates to:
  /// **'Total Assignments'**
  String get totalAssignments;

  /// No description provided for @rolesInUse.
  ///
  /// In en, this message translates to:
  /// **'Roles in Use'**
  String get rolesInUse;

  /// No description provided for @usersWithMultipleRoles.
  ///
  /// In en, this message translates to:
  /// **'Users with Multiple Roles'**
  String get usersWithMultipleRoles;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @currentRoles.
  ///
  /// In en, this message translates to:
  /// **'Current Roles'**
  String get currentRoles;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @roleManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage roles, permissions, and access levels'**
  String get roleManagementSubtitle;

  /// No description provided for @dutyRolesOnly.
  ///
  /// In en, this message translates to:
  /// **'Duty Roles'**
  String get dutyRolesOnly;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @allTypesFilter.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypesFilter;

  /// No description provided for @allStatusFilter.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatusFilter;

  /// No description provided for @searchRolesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search roles by name or code...'**
  String get searchRolesPlaceholder;

  /// No description provided for @roleType.
  ///
  /// In en, this message translates to:
  /// **'Role Type'**
  String get roleType;

  /// No description provided for @usersAssigned.
  ///
  /// In en, this message translates to:
  /// **'Users Assigned ({count})'**
  String usersAssigned(int count);

  /// No description provided for @privileges.
  ///
  /// In en, this message translates to:
  /// **'Privileges'**
  String get privileges;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created On'**
  String get createdOn;

  /// No description provided for @createRole.
  ///
  /// In en, this message translates to:
  /// **'Create Role'**
  String get createRole;

  /// No description provided for @createNewRole.
  ///
  /// In en, this message translates to:
  /// **'Create New Role'**
  String get createNewRole;

  /// No description provided for @editRole.
  ///
  /// In en, this message translates to:
  /// **'Edit Role'**
  String get editRole;

  /// No description provided for @roleInformation.
  ///
  /// In en, this message translates to:
  /// **'Role Information'**
  String get roleInformation;

  /// No description provided for @roleName.
  ///
  /// In en, this message translates to:
  /// **'Role Name'**
  String get roleName;

  /// No description provided for @enterRoleName.
  ///
  /// In en, this message translates to:
  /// **'Enter role name'**
  String get enterRoleName;

  /// No description provided for @roleCode.
  ///
  /// In en, this message translates to:
  /// **'Role Code'**
  String get roleCode;

  /// No description provided for @enterRoleCode.
  ///
  /// In en, this message translates to:
  /// **'Enter role code (e.g., FIN_MGR_001)'**
  String get enterRoleCode;

  /// No description provided for @roleDescription.
  ///
  /// In en, this message translates to:
  /// **'Role Description'**
  String get roleDescription;

  /// No description provided for @enterRoleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter role description'**
  String get enterRoleDescription;

  /// No description provided for @roleConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Role Configuration'**
  String get roleConfiguration;

  /// No description provided for @selectRoleType.
  ///
  /// In en, this message translates to:
  /// **'Select Role Type'**
  String get selectRoleType;

  /// No description provided for @jobRole.
  ///
  /// In en, this message translates to:
  /// **'Job Role'**
  String get jobRole;

  /// No description provided for @dutyRole.
  ///
  /// In en, this message translates to:
  /// **'Duty Role'**
  String get dutyRole;

  /// No description provided for @effectiveDates.
  ///
  /// In en, this message translates to:
  /// **'Effective Dates'**
  String get effectiveDates;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @setActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Set Active Status'**
  String get setActiveStatus;

  /// No description provided for @setStatus.
  ///
  /// In en, this message translates to:
  /// **'Set Status'**
  String get setStatus;

  /// No description provided for @privilegesAndAccess.
  ///
  /// In en, this message translates to:
  /// **'Privileges & Access'**
  String get privilegesAndAccess;

  /// No description provided for @functionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Function Security'**
  String get functionSecurity;

  /// No description provided for @function.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get function;

  /// No description provided for @accessLevel.
  ///
  /// In en, this message translates to:
  /// **'Access Level'**
  String get accessLevel;

  /// No description provided for @addPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Add Privilege'**
  String get addPrivilege;

  /// No description provided for @dataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Data Access Set'**
  String get dataAccessSet;

  /// No description provided for @assignDataSets.
  ///
  /// In en, this message translates to:
  /// **'Assign Data Sets'**
  String get assignDataSets;

  /// No description provided for @roleCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Role created successfully'**
  String get roleCreatedSuccessfully;

  /// No description provided for @roleUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Role updated successfully'**
  String get roleUpdatedSuccessfully;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @roleHierarchySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage role hierarchy structure'**
  String get roleHierarchySubtitle;

  /// No description provided for @totalNodes.
  ///
  /// In en, this message translates to:
  /// **'Total Nodes'**
  String get totalNodes;

  /// No description provided for @maxDepth.
  ///
  /// In en, this message translates to:
  /// **'Max Depth'**
  String get maxDepth;

  /// No description provided for @parentRoles.
  ///
  /// In en, this message translates to:
  /// **'Parent Roles'**
  String get parentRoles;

  /// No description provided for @parentRole.
  ///
  /// In en, this message translates to:
  /// **'Parent Role'**
  String get parentRole;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @childRoles.
  ///
  /// In en, this message translates to:
  /// **'Child Roles'**
  String get childRoles;

  /// No description provided for @searchHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Search hierarchy...'**
  String get searchHierarchy;

  /// No description provided for @expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get expandAll;

  /// No description provided for @collapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse All'**
  String get collapseAll;

  /// No description provided for @createRootRole.
  ///
  /// In en, this message translates to:
  /// **'Create Root Role'**
  String get createRootRole;

  /// No description provided for @usersAssignedLabel.
  ///
  /// In en, this message translates to:
  /// **'Users Assigned'**
  String get usersAssignedLabel;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryAdjustingSearchCriteria.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria'**
  String get tryAdjustingSearchCriteria;

  /// No description provided for @addRoleToHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Add Role to Hierarchy'**
  String get addRoleToHierarchy;

  /// No description provided for @selectParentRole.
  ///
  /// In en, this message translates to:
  /// **'Select Parent Role (Optional)'**
  String get selectParentRole;

  /// No description provided for @selectParent.
  ///
  /// In en, this message translates to:
  /// **'Select parent role...'**
  String get selectParent;

  /// No description provided for @noParentRole.
  ///
  /// In en, this message translates to:
  /// **'No Parent (Root Level)'**
  String get noParentRole;

  /// No description provided for @existingRole.
  ///
  /// In en, this message translates to:
  /// **'Existing Role'**
  String get existingRole;

  /// No description provided for @selectExistingRole.
  ///
  /// In en, this message translates to:
  /// **'Select existing role'**
  String get selectExistingRole;

  /// No description provided for @newRoleName.
  ///
  /// In en, this message translates to:
  /// **'New Role Name'**
  String get newRoleName;

  /// No description provided for @enterNewRoleName.
  ///
  /// In en, this message translates to:
  /// **'Enter new role name'**
  String get enterNewRoleName;

  /// No description provided for @roleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Role Type'**
  String get roleTypeLabel;

  /// No description provided for @addRole.
  ///
  /// In en, this message translates to:
  /// **'Add Role'**
  String get addRole;

  /// No description provided for @roleTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-configured role templates for quick setup'**
  String get roleTemplatesSubtitle;

  /// No description provided for @totalTemplates.
  ///
  /// In en, this message translates to:
  /// **'Total Templates'**
  String get totalTemplates;

  /// No description provided for @industrySpecific.
  ///
  /// In en, this message translates to:
  /// **'Industry Specific'**
  String get industrySpecific;

  /// No description provided for @recentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently Used'**
  String get recentlyUsed;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @operations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get hr;

  /// No description provided for @it.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get it;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplate;

  /// No description provided for @useTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use Template'**
  String get useTemplate;

  /// No description provided for @includes.
  ///
  /// In en, this message translates to:
  /// **'Includes'**
  String get includes;

  /// No description provided for @privilegesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Privileges'**
  String privilegesCount(int count);

  /// No description provided for @dataSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Data Sets'**
  String dataSetsCount(int count);

  /// No description provided for @createNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create New Template'**
  String get createNewTemplate;

  /// No description provided for @creatingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Creating Template'**
  String get creatingTemplate;

  /// No description provided for @templateInstructions.
  ///
  /// In en, this message translates to:
  /// **'Create a reusable role template with pre-configured permissions and access settings'**
  String get templateInstructions;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get templateName;

  /// No description provided for @enterTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Enter template name'**
  String get enterTemplateName;

  /// No description provided for @templateCode.
  ///
  /// In en, this message translates to:
  /// **'Template Code'**
  String get templateCode;

  /// No description provided for @enterTemplateCode.
  ///
  /// In en, this message translates to:
  /// **'Enter unique template code'**
  String get enterTemplateCode;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @templateDescription.
  ///
  /// In en, this message translates to:
  /// **'Template Description'**
  String get templateDescription;

  /// No description provided for @enterTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter template description'**
  String get enterTemplateDescription;

  /// No description provided for @includedPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Included Privileges'**
  String get includedPrivileges;

  /// No description provided for @selectPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Select Privileges'**
  String get selectPrivileges;

  /// No description provided for @selectedPrivileges.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedPrivileges(int count);

  /// No description provided for @includedDataSets.
  ///
  /// In en, this message translates to:
  /// **'Included Data Sets'**
  String get includedDataSets;

  /// No description provided for @selectDataSets.
  ///
  /// In en, this message translates to:
  /// **'Select Data Sets'**
  String get selectDataSets;

  /// No description provided for @selectedDataSets.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedDataSets(int count);

  /// No description provided for @makeDefaultTemplate.
  ///
  /// In en, this message translates to:
  /// **'Make Default Template'**
  String get makeDefaultTemplate;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default for this category'**
  String get setAsDefault;

  /// No description provided for @createTemplateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get createTemplateButton;

  /// No description provided for @securityPoliciesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure and manage security policies'**
  String get securityPoliciesSubtitle;

  /// No description provided for @activePolicies.
  ///
  /// In en, this message translates to:
  /// **'Active Policies'**
  String get activePolicies;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get pendingReview;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @searchPolicies.
  ///
  /// In en, this message translates to:
  /// **'Search policies...'**
  String get searchPolicies;

  /// No description provided for @createPolicy.
  ///
  /// In en, this message translates to:
  /// **'Create Policy'**
  String get createPolicy;

  /// No description provided for @policyType.
  ///
  /// In en, this message translates to:
  /// **'Policy Type'**
  String get policyType;

  /// No description provided for @enforcementLevel.
  ///
  /// In en, this message translates to:
  /// **'Enforcement Level'**
  String get enforcementLevel;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last Modified'**
  String get lastModified;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @createNewPolicy.
  ///
  /// In en, this message translates to:
  /// **'Create New Policy'**
  String get createNewPolicy;

  /// No description provided for @editPolicy.
  ///
  /// In en, this message translates to:
  /// **'Edit Policy'**
  String get editPolicy;

  /// No description provided for @creatingPolicy.
  ///
  /// In en, this message translates to:
  /// **'Creating Policy'**
  String get creatingPolicy;

  /// No description provided for @policyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Define security policies to enforce access control and compliance'**
  String get policyInstructions;

  /// No description provided for @policyName.
  ///
  /// In en, this message translates to:
  /// **'Policy Name'**
  String get policyName;

  /// No description provided for @enterPolicyName.
  ///
  /// In en, this message translates to:
  /// **'Enter policy name'**
  String get enterPolicyName;

  /// No description provided for @policyCode.
  ///
  /// In en, this message translates to:
  /// **'Policy Code'**
  String get policyCode;

  /// No description provided for @enterPolicyCode.
  ///
  /// In en, this message translates to:
  /// **'Enter policy code'**
  String get enterPolicyCode;

  /// No description provided for @policyDescription.
  ///
  /// In en, this message translates to:
  /// **'Policy Description'**
  String get policyDescription;

  /// No description provided for @enterPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter policy description'**
  String get enterPolicyDescription;

  /// No description provided for @selectPolicyType.
  ///
  /// In en, this message translates to:
  /// **'Select Policy Type'**
  String get selectPolicyType;

  /// No description provided for @passwordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Password Policy'**
  String get passwordPolicy;

  /// No description provided for @accessPolicy.
  ///
  /// In en, this message translates to:
  /// **'Access Policy'**
  String get accessPolicy;

  /// No description provided for @compliancePolicy.
  ///
  /// In en, this message translates to:
  /// **'Compliance Policy'**
  String get compliancePolicy;

  /// No description provided for @selectEnforcementLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Enforcement Level'**
  String get selectEnforcementLevel;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'Mandatory'**
  String get mandatory;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @enterExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter expiry date'**
  String get enterExpiryDate;

  /// No description provided for @policyRules.
  ///
  /// In en, this message translates to:
  /// **'Policy Rules'**
  String get policyRules;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Add Rule'**
  String get addRule;

  /// No description provided for @createPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'Create Policy'**
  String get createPolicyButton;

  /// No description provided for @dataAccessSetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage data access sets and permissions'**
  String get dataAccessSetsSubtitle;

  /// No description provided for @totalDataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Total Data Access Sets'**
  String get totalDataAccessSets;

  /// No description provided for @ledgerBased.
  ///
  /// In en, this message translates to:
  /// **'Ledger Based'**
  String get ledgerBased;

  /// No description provided for @entityBased.
  ///
  /// In en, this message translates to:
  /// **'Entity Based'**
  String get entityBased;

  /// No description provided for @searchDataAccessSets.
  ///
  /// In en, this message translates to:
  /// **'Search data access sets...'**
  String get searchDataAccessSets;

  /// No description provided for @createDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Create Data Access Set'**
  String get createDataAccessSet;

  /// No description provided for @accessScope.
  ///
  /// In en, this message translates to:
  /// **'Access Scope'**
  String get accessScope;

  /// No description provided for @createNewDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Create New Data Access Set'**
  String get createNewDataAccessSet;

  /// No description provided for @creatingDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Creating Data Access Set'**
  String get creatingDataAccessSet;

  /// No description provided for @dataAccessSetInstructions.
  ///
  /// In en, this message translates to:
  /// **'Define data access boundaries for controlling which data users can view and modify'**
  String get dataAccessSetInstructions;

  /// No description provided for @setName.
  ///
  /// In en, this message translates to:
  /// **'Set Name'**
  String get setName;

  /// No description provided for @enterDataAccessSetName.
  ///
  /// In en, this message translates to:
  /// **'Enter data access set name'**
  String get enterDataAccessSetName;

  /// No description provided for @setCode.
  ///
  /// In en, this message translates to:
  /// **'Set Code'**
  String get setCode;

  /// No description provided for @enterSetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter set code'**
  String get enterSetCode;

  /// No description provided for @accessType.
  ///
  /// In en, this message translates to:
  /// **'Access Type'**
  String get accessType;

  /// No description provided for @dataAccessConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Data Access Configuration'**
  String get dataAccessConfiguration;

  /// No description provided for @accessCriteriaChooseOne.
  ///
  /// In en, this message translates to:
  /// **'Access Criteria (Choose One)'**
  String get accessCriteriaChooseOne;

  /// No description provided for @selectAccessCriteria.
  ///
  /// In en, this message translates to:
  /// **'Select access criteria'**
  String get selectAccessCriteria;

  /// No description provided for @ledgersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} Ledgers Selected'**
  String ledgersSelected(int count);

  /// No description provided for @noLedgersFound.
  ///
  /// In en, this message translates to:
  /// **'No ledgers found'**
  String get noLedgersFound;

  /// No description provided for @legalEntitiesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} Legal Entities Selected'**
  String legalEntitiesSelected(int count);

  /// No description provided for @noLegalEntitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No legal entities found'**
  String get noLegalEntitiesFound;

  /// No description provided for @createSet.
  ///
  /// In en, this message translates to:
  /// **'Create Set'**
  String get createSet;

  /// No description provided for @editDataAccessSet.
  ///
  /// In en, this message translates to:
  /// **'Edit Data Access Set'**
  String get editDataAccessSet;

  /// No description provided for @updateSet.
  ///
  /// In en, this message translates to:
  /// **'Update Set'**
  String get updateSet;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description (optional)'**
  String get enterDescription;

  /// No description provided for @noDataAccessSetsFound.
  ///
  /// In en, this message translates to:
  /// **'No data access sets found'**
  String get noDataAccessSetsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search criteria'**
  String get tryAdjustingFilters;

  /// No description provided for @noPoliciesFound.
  ///
  /// In en, this message translates to:
  /// **'No policies found'**
  String get noPoliciesFound;

  /// No description provided for @noTemplatesFound.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get noTemplatesFound;

  /// No description provided for @noRolesFound.
  ///
  /// In en, this message translates to:
  /// **'No roles found'**
  String get noRolesFound;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @noPrivilegesFound.
  ///
  /// In en, this message translates to:
  /// **'No privileges found'**
  String get noPrivilegesFound;

  /// No description provided for @functionPrivilegesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage function-level security privileges'**
  String get functionPrivilegesSubtitle;

  /// No description provided for @createPrivilege.
  ///
  /// In en, this message translates to:
  /// **'Create Privilege'**
  String get createPrivilege;

  /// No description provided for @searchPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Search privileges...'**
  String get searchPrivileges;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @usedInRolesCount.
  ///
  /// In en, this message translates to:
  /// **'Used in {count} roles'**
  String usedInRolesCount(int count);

  /// No description provided for @functionArea.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get functionArea;

  /// No description provided for @actionType.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get actionType;

  /// No description provided for @selectActionType.
  ///
  /// In en, this message translates to:
  /// **'Select Operation'**
  String get selectActionType;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @createPrivilegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Function Privilege'**
  String get createPrivilegeTitle;

  /// No description provided for @editPrivilegeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Function Privilege'**
  String get editPrivilegeTitle;

  /// No description provided for @privilegeName.
  ///
  /// In en, this message translates to:
  /// **'Privilege Name'**
  String get privilegeName;

  /// No description provided for @enterPrivilegeName.
  ///
  /// In en, this message translates to:
  /// **'Enter privilege name'**
  String get enterPrivilegeName;

  /// No description provided for @privilegeCode.
  ///
  /// In en, this message translates to:
  /// **'Privilege Code'**
  String get privilegeCode;

  /// No description provided for @enterPrivilegeCode.
  ///
  /// In en, this message translates to:
  /// **'Enter privilege code'**
  String get enterPrivilegeCode;

  /// No description provided for @privilegeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get privilegeDescription;

  /// No description provided for @selectModule.
  ///
  /// In en, this message translates to:
  /// **'Select Module'**
  String get selectModule;

  /// No description provided for @privilegeCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Privilege created successfully'**
  String get privilegeCreatedSuccessfully;

  /// No description provided for @privilegeUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Privilege updated successfully'**
  String get privilegeUpdatedSuccessfully;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get module;

  /// No description provided for @privilege.
  ///
  /// In en, this message translates to:
  /// **'Privilege'**
  String get privilege;

  /// No description provided for @rootRoles.
  ///
  /// In en, this message translates to:
  /// **'Root Roles'**
  String get rootRoles;

  /// No description provided for @hierarchyStructure.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Structure'**
  String get hierarchyStructure;

  /// No description provided for @saveRole.
  ///
  /// In en, this message translates to:
  /// **'Save Role'**
  String get saveRole;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @pleaseEnterRoleName.
  ///
  /// In en, this message translates to:
  /// **'Please enter role name'**
  String get pleaseEnterRoleName;

  /// No description provided for @pleaseEnterRoleCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter role code'**
  String get pleaseEnterRoleCode;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @activeRole.
  ///
  /// In en, this message translates to:
  /// **'Active Role'**
  String get activeRole;

  /// No description provided for @assignPrivileges.
  ///
  /// In en, this message translates to:
  /// **'Assign Privileges'**
  String get assignPrivileges;

  /// No description provided for @functions.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get functions;

  /// No description provided for @securityIncidents.
  ///
  /// In en, this message translates to:
  /// **'Security Incidents'**
  String get securityIncidents;

  /// No description provided for @securityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Security Alerts'**
  String get securityAlerts;

  /// No description provided for @recentSecurityActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Security Activities'**
  String get recentSecurityActivities;

  /// No description provided for @configureDataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Configure Data Security'**
  String get configureDataSecurity;

  /// No description provided for @viewAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'View Audit Logs'**
  String get viewAuditLogs;

  /// No description provided for @passwordPolicyCompliance.
  ///
  /// In en, this message translates to:
  /// **'Password Policy Compliance'**
  String get passwordPolicyCompliance;

  /// No description provided for @multiFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Multi-Factor Authentication'**
  String get multiFactorAuthentication;

  /// No description provided for @activeUserReview.
  ///
  /// In en, this message translates to:
  /// **'Active User Review'**
  String get activeUserReview;

  /// No description provided for @segregationOfDuties.
  ///
  /// In en, this message translates to:
  /// **'Segregation of Duties'**
  String get segregationOfDuties;

  /// No description provided for @complianceStatus.
  ///
  /// In en, this message translates to:
  /// **'Compliance Status'**
  String get complianceStatus;

  /// No description provided for @passwordsExpiring.
  ///
  /// In en, this message translates to:
  /// **'Passwords Expiring'**
  String get passwordsExpiring;

  /// No description provided for @complianceScore.
  ///
  /// In en, this message translates to:
  /// **'Compliance Score'**
  String get complianceScore;

  /// No description provided for @tasksEvents.
  ///
  /// In en, this message translates to:
  /// **'Tasks & Events'**
  String get tasksEvents;

  /// No description provided for @attendanceLeaves.
  ///
  /// In en, this message translates to:
  /// **'Attendance & Leaves'**
  String get attendanceLeaves;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'MY TASKS'**
  String get myTasks;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING EVENTS'**
  String get upcomingEvents;

  /// No description provided for @reviewLeaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Review pending leave requests'**
  String get reviewLeaveRequests;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @processMonthlyPayroll.
  ///
  /// In en, this message translates to:
  /// **'Process monthly payroll'**
  String get processMonthlyPayroll;

  /// No description provided for @dueIn3Days.
  ///
  /// In en, this message translates to:
  /// **'Due in 3 days'**
  String get dueIn3Days;

  /// No description provided for @updateEmployeeRecords.
  ///
  /// In en, this message translates to:
  /// **'Update employee records'**
  String get updateEmployeeRecords;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @teamMeeting.
  ///
  /// In en, this message translates to:
  /// **'Team Meeting'**
  String get teamMeeting;

  /// No description provided for @payrollProcessing.
  ///
  /// In en, this message translates to:
  /// **'Payroll Processing'**
  String get payrollProcessing;

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All-day'**
  String get allDay;

  /// No description provided for @viewAllTasksEvents.
  ///
  /// In en, this message translates to:
  /// **'View All Tasks & Events'**
  String get viewAllTasksEvents;

  /// No description provided for @todaysAttendance.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S ATTENDANCE'**
  String get todaysAttendance;

  /// No description provided for @checkInTime.
  ///
  /// In en, this message translates to:
  /// **'Check In Time'**
  String get checkInTime;

  /// No description provided for @statusOnTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get statusOnTime;

  /// No description provided for @myUpcomingLeaves.
  ///
  /// In en, this message translates to:
  /// **'MY UPCOMING LEAVES'**
  String get myUpcomingLeaves;

  /// No description provided for @annualLeave.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave'**
  String get annualLeave;

  /// No description provided for @leaveDates.
  ///
  /// In en, this message translates to:
  /// **'Dec 25 - Dec 30, 2024'**
  String get leaveDates;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @teamOnLeaveToday.
  ///
  /// In en, this message translates to:
  /// **'TEAM ON LEAVE TODAY'**
  String get teamOnLeaveToday;

  /// No description provided for @ahmadHassan.
  ///
  /// In en, this message translates to:
  /// **'Ahmad Hassan'**
  String get ahmadHassan;

  /// No description provided for @sickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get sickLeave;

  /// No description provided for @mohammedKhan.
  ///
  /// In en, this message translates to:
  /// **'Mohammed Khan'**
  String get mohammedKhan;

  /// No description provided for @emergencyLeave.
  ///
  /// In en, this message translates to:
  /// **'Emergency Leave'**
  String get emergencyLeave;

  /// No description provided for @viewFullCalendar.
  ///
  /// In en, this message translates to:
  /// **'View Full Calendar'**
  String get viewFullCalendar;

  /// No description provided for @adminUser.
  ///
  /// In en, this message translates to:
  /// **'Admin User'**
  String get adminUser;

  /// No description provided for @welcomeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Admin User'**
  String get welcomeAdmin;

  /// No description provided for @timeManagement.
  ///
  /// In en, this message translates to:
  /// **'Time Management'**
  String get timeManagement;

  /// No description provided for @leaveManagement.
  ///
  /// In en, this message translates to:
  /// **'Leave Management'**
  String get leaveManagement;

  /// No description provided for @workforceStructure.
  ///
  /// In en, this message translates to:
  /// **'Workforce Structure'**
  String get workforceStructure;

  /// No description provided for @eosCalculator.
  ///
  /// In en, this message translates to:
  /// **'EOS Calculator'**
  String get eosCalculator;

  /// No description provided for @governmentForms.
  ///
  /// In en, this message translates to:
  /// **'Government Forms'**
  String get governmentForms;

  /// No description provided for @hrOperations.
  ///
  /// In en, this message translates to:
  /// **'HR Operations'**
  String get hrOperations;

  /// No description provided for @deiDashboard.
  ///
  /// In en, this message translates to:
  /// **'DEI Dashboard'**
  String get deiDashboard;

  /// No description provided for @moduleCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Module Catalogue'**
  String get moduleCatalogue;

  /// No description provided for @productIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Product Introduction'**
  String get productIntroduction;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @payroll.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payroll;

  /// No description provided for @compliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance'**
  String get compliance;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @manageEnterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Manage Enterprise Structure'**
  String get manageEnterpriseStructure;

  /// No description provided for @configureManageHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Configure and manage your organizational hierarchy structures'**
  String get configureManageHierarchy;

  /// No description provided for @configureManageHierarchyAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة وتكوين هياكل التسلسل الإداري للمؤسسة'**
  String get configureManageHierarchyAr;

  /// No description provided for @currentlyActiveStructure.
  ///
  /// In en, this message translates to:
  /// **'Currently Active Structure'**
  String get currentlyActiveStructure;

  /// No description provided for @standardKuwaitCorporateStructure.
  ///
  /// In en, this message translates to:
  /// **'Standard Kuwait Corporate Structure'**
  String get standardKuwaitCorporateStructure;

  /// No description provided for @traditionalHierarchicalStructure.
  ///
  /// In en, this message translates to:
  /// **'Traditional hierarchical structure with all five levels for comprehensive organizational management'**
  String get traditionalHierarchicalStructure;

  /// No description provided for @activeLevels.
  ///
  /// In en, this message translates to:
  /// **'Active Levels'**
  String get activeLevels;

  /// No description provided for @components.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @employeesAssigned.
  ///
  /// In en, this message translates to:
  /// **'Employees Assigned'**
  String get employeesAssigned;

  /// No description provided for @totalStructures.
  ///
  /// In en, this message translates to:
  /// **'Total Structures'**
  String get totalStructures;

  /// No description provided for @activeStructure.
  ///
  /// In en, this message translates to:
  /// **'Active Structure'**
  String get activeStructure;

  /// No description provided for @componentsInUse.
  ///
  /// In en, this message translates to:
  /// **'Components in Use'**
  String get componentsInUse;

  /// No description provided for @structureConfigurations.
  ///
  /// In en, this message translates to:
  /// **'Structure Configurations'**
  String get structureConfigurations;

  /// No description provided for @manageDifferentConfigurations.
  ///
  /// In en, this message translates to:
  /// **'Manage different organizational hierarchy configurations. Only one can be active at a time.'**
  String get manageDifferentConfigurations;

  /// No description provided for @createNewStructure.
  ///
  /// In en, this message translates to:
  /// **'Create New Structure'**
  String get createNewStructure;

  /// No description provided for @hierarchy.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy'**
  String get hierarchy;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'levels'**
  String get levels;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @modified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modified;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @notUsed.
  ///
  /// In en, this message translates to:
  /// **'NOT USED'**
  String get notUsed;

  /// No description provided for @simplifiedStructure.
  ///
  /// In en, this message translates to:
  /// **'Simplified Structure'**
  String get simplifiedStructure;

  /// No description provided for @streamlinedStructure.
  ///
  /// In en, this message translates to:
  /// **'Streamlined structure for smaller organizations - Company, Division, and Department only'**
  String get streamlinedStructure;

  /// No description provided for @flatOrganizationStructure.
  ///
  /// In en, this message translates to:
  /// **'Flat Organization Structure'**
  String get flatOrganizationStructure;

  /// No description provided for @minimalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Minimal hierarchy for startups and agile teams - Company and Department only'**
  String get minimalHierarchy;

  /// No description provided for @currentlyActiveStructureMessage.
  ///
  /// In en, this message translates to:
  /// **'This is the currently active structure. To activate a different structure, click the \"Activate\" button on another configuration.'**
  String get currentlyActiveStructureMessage;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @divisions.
  ///
  /// In en, this message translates to:
  /// **'Divisions'**
  String get divisions;

  /// No description provided for @businessUnit.
  ///
  /// In en, this message translates to:
  /// **'Business Unit'**
  String get businessUnit;

  /// No description provided for @businessUnits.
  ///
  /// In en, this message translates to:
  /// **'Business Units'**
  String get businessUnits;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// No description provided for @section.
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// No description provided for @sections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get sections;

  /// No description provided for @companyCode.
  ///
  /// In en, this message translates to:
  /// **'Company Code'**
  String get companyCode;

  /// No description provided for @companyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Company Name (English)'**
  String get companyNameEnglish;

  /// No description provided for @companyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Company Name (Arabic)'**
  String get companyNameArabic;

  /// No description provided for @legalNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Legal Name (English)'**
  String get legalNameEnglish;

  /// No description provided for @legalNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Legal Name (Arabic)'**
  String get legalNameArabic;

  /// No description provided for @industry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industry;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @poBox.
  ///
  /// In en, this message translates to:
  /// **'P.O. Box'**
  String get poBox;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @fiscalYearStart.
  ///
  /// In en, this message translates to:
  /// **'Fiscal Year Start (MM-DD)'**
  String get fiscalYearStart;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @viewEnterpriseStructureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'View Enterprise Structure Configuration'**
  String get viewEnterpriseStructureConfiguration;

  /// No description provided for @reviewOrganizationalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Review organizational hierarchy levels and sequence'**
  String get reviewOrganizationalHierarchy;

  /// No description provided for @structureConfigurationActive.
  ///
  /// In en, this message translates to:
  /// **'Structure Configuration Active'**
  String get structureConfigurationActive;

  /// No description provided for @enterpriseStructureActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Your enterprise structure hierarchy is configured and active. You can modify the levels and order below.'**
  String get enterpriseStructureActiveMessage;

  /// No description provided for @configurationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Configuration Instructions'**
  String get configurationInstructions;

  /// No description provided for @companyMandatoryInstruction.
  ///
  /// In en, this message translates to:
  /// **'Company is mandatory and must be the top level - it cannot be disabled or reordered'**
  String get companyMandatoryInstruction;

  /// No description provided for @enableDisableLevelsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable levels based on your organizational needs'**
  String get enableDisableLevelsInstruction;

  /// No description provided for @useArrowsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Use the up/down arrows to change the hierarchy sequence'**
  String get useArrowsInstruction;

  /// No description provided for @orderDeterminesRelationshipsInstruction.
  ///
  /// In en, this message translates to:
  /// **'The order determines parent-child relationships in your org structure'**
  String get orderDeterminesRelationshipsInstruction;

  /// No description provided for @changesAffectComponentsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Changes will affect how components are created and displayed in the tree view'**
  String get changesAffectComponentsInstruction;

  /// No description provided for @previewStructure.
  ///
  /// In en, this message translates to:
  /// **'Preview Structure'**
  String get previewStructure;

  /// No description provided for @saveConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Save Configuration'**
  String get saveConfiguration;

  /// No description provided for @organizationalHierarchyLevels.
  ///
  /// In en, this message translates to:
  /// **'Organizational Hierarchy Levels'**
  String get organizationalHierarchyLevels;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @levelInHierarchy.
  ///
  /// In en, this message translates to:
  /// **'{level}'**
  String levelInHierarchy(int level);

  /// No description provided for @hierarchyPreview.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Preview'**
  String get hierarchyPreview;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'{levelNumber}'**
  String level(int levelNumber);

  /// No description provided for @configurationSummary.
  ///
  /// In en, this message translates to:
  /// **'Configuration Summary'**
  String get configurationSummary;

  /// No description provided for @totalLevels.
  ///
  /// In en, this message translates to:
  /// **'Total Levels'**
  String get totalLevels;

  /// No description provided for @hierarchyDepth.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Depth'**
  String get hierarchyDepth;

  /// No description provided for @topLevel.
  ///
  /// In en, this message translates to:
  /// **'Top Level'**
  String get topLevel;

  /// No description provided for @editEnterpriseStructureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Edit Enterprise Structure Configuration'**
  String get editEnterpriseStructureConfiguration;

  /// No description provided for @defineOrganizationalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Define your organizational hierarchy levels and sequence'**
  String get defineOrganizationalHierarchy;

  /// No description provided for @createEnterpriseStructureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Create Enterprise Structure Configuration'**
  String get createEnterpriseStructureConfiguration;

  /// No description provided for @noConfigurationFound.
  ///
  /// In en, this message translates to:
  /// **'No Configuration Found'**
  String get noConfigurationFound;

  /// No description provided for @pleaseConfigureEnterpriseStructure.
  ///
  /// In en, this message translates to:
  /// **'Please configure your enterprise structure hierarchy before creating components.'**
  String get pleaseConfigureEnterpriseStructure;

  /// No description provided for @structureName.
  ///
  /// In en, this message translates to:
  /// **'Structure Name'**
  String get structureName;

  /// No description provided for @structureNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Standard Corporate Structure, Simplified Structure'**
  String get structureNamePlaceholder;

  /// No description provided for @descriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe this structure configuration and when it should be used...'**
  String get descriptionPlaceholder;

  /// No description provided for @manageComponentValues.
  ///
  /// In en, this message translates to:
  /// **'Manage Component Values'**
  String get manageComponentValues;

  /// No description provided for @componentValuesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and manage organizational components (Company, Division, Business Unit, Department, Section)'**
  String get componentValuesSubtitle;

  /// No description provided for @manageOrganizationalHierarchy.
  ///
  /// In en, this message translates to:
  /// **'Manage organizational hierarchy and structure'**
  String get manageOrganizationalHierarchy;

  /// No description provided for @manageOrganizationalHierarchyAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة الهيكل التنظيمي والتسلسل الإداري'**
  String get manageOrganizationalHierarchyAr;

  /// No description provided for @structureConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Structure Configuration'**
  String get structureConfiguration;

  /// No description provided for @organizationalTreeStructure.
  ///
  /// In en, this message translates to:
  /// **'Organizational Tree Structure'**
  String get organizationalTreeStructure;

  /// No description provided for @addNewComponent.
  ///
  /// In en, this message translates to:
  /// **'Add New Component'**
  String get addNewComponent;

  /// No description provided for @bulkUpload.
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload'**
  String get bulkUpload;

  /// No description provided for @bulkUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload - Enterprise Structure Components'**
  String get bulkUploadTitle;

  /// No description provided for @bulkUploadInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Instructions'**
  String get bulkUploadInstructionsTitle;

  /// No description provided for @bulkUploadInstructionDownloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download the template file to see the required format'**
  String get bulkUploadInstructionDownloadTemplate;

  /// No description provided for @bulkUploadInstructionRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all required fields: Type, Code, Name, Name Arabic, Parent Code (if applicable)'**
  String get bulkUploadInstructionRequiredFields;

  /// No description provided for @bulkUploadInstructionOptionalFields.
  ///
  /// In en, this message translates to:
  /// **'Optional fields: Manager ID, Cost Center, Location, Description'**
  String get bulkUploadInstructionOptionalFields;

  /// No description provided for @bulkUploadInstructionParentCode.
  ///
  /// In en, this message translates to:
  /// **'Parent Code must match an existing component code'**
  String get bulkUploadInstructionParentCode;

  /// No description provided for @bulkUploadInstructionFileFormat.
  ///
  /// In en, this message translates to:
  /// **'File format: Excel (.xlsx) or CSV (.csv)'**
  String get bulkUploadInstructionFileFormat;

  /// No description provided for @bulkUploadInstructionRowLimit.
  ///
  /// In en, this message translates to:
  /// **'Maximum 1000 rows per upload'**
  String get bulkUploadInstructionRowLimit;

  /// No description provided for @bulkUploadStepDownloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Download Template'**
  String get bulkUploadStepDownloadLabel;

  /// No description provided for @bulkUploadDownloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download Excel Template'**
  String get bulkUploadDownloadTemplate;

  /// No description provided for @bulkUploadStepUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Upload Filled Template'**
  String get bulkUploadStepUploadLabel;

  /// No description provided for @bulkUploadDropHint.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop your file here, or click to browse'**
  String get bulkUploadDropHint;

  /// No description provided for @bulkUploadSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supports: .xlsx, .csv (Max size: 10MB)'**
  String get bulkUploadSupportedFormats;

  /// No description provided for @bulkUploadTemplatePreview.
  ///
  /// In en, this message translates to:
  /// **'Template Format Preview'**
  String get bulkUploadTemplatePreview;

  /// No description provided for @bulkUploadTypeHeader.
  ///
  /// In en, this message translates to:
  /// **'Type*'**
  String get bulkUploadTypeHeader;

  /// No description provided for @bulkUploadCodeHeader.
  ///
  /// In en, this message translates to:
  /// **'Code*'**
  String get bulkUploadCodeHeader;

  /// No description provided for @bulkUploadNameHeader.
  ///
  /// In en, this message translates to:
  /// **'Name*'**
  String get bulkUploadNameHeader;

  /// No description provided for @bulkUploadNameArabicHeader.
  ///
  /// In en, this message translates to:
  /// **'Name Arabic*'**
  String get bulkUploadNameArabicHeader;

  /// No description provided for @bulkUploadParentCodeHeader.
  ///
  /// In en, this message translates to:
  /// **'Parent Code'**
  String get bulkUploadParentCodeHeader;

  /// No description provided for @bulkUploadManagerIdHeader.
  ///
  /// In en, this message translates to:
  /// **'Manager ID'**
  String get bulkUploadManagerIdHeader;

  /// No description provided for @bulkUploadLocationHeader.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get bulkUploadLocationHeader;

  /// No description provided for @bulkUploadSampleRow1Type.
  ///
  /// In en, this message translates to:
  /// **'company'**
  String get bulkUploadSampleRow1Type;

  /// No description provided for @bulkUploadSampleRow1Code.
  ///
  /// In en, this message translates to:
  /// **'COMP-001'**
  String get bulkUploadSampleRow1Code;

  /// No description provided for @bulkUploadSampleRow1Name.
  ///
  /// In en, this message translates to:
  /// **'Main Company'**
  String get bulkUploadSampleRow1Name;

  /// No description provided for @bulkUploadSampleRow1NameArabic.
  ///
  /// In en, this message translates to:
  /// **'الشركة الرئيسية'**
  String get bulkUploadSampleRow1NameArabic;

  /// No description provided for @bulkUploadSampleRow1ParentCode.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get bulkUploadSampleRow1ParentCode;

  /// No description provided for @bulkUploadSampleRow1ManagerId.
  ///
  /// In en, this message translates to:
  /// **'EMP-001'**
  String get bulkUploadSampleRow1ManagerId;

  /// No description provided for @bulkUploadSampleRow1Location.
  ///
  /// In en, this message translates to:
  /// **'Kuwait City'**
  String get bulkUploadSampleRow1Location;

  /// No description provided for @bulkUploadSampleRow2Type.
  ///
  /// In en, this message translates to:
  /// **'division'**
  String get bulkUploadSampleRow2Type;

  /// No description provided for @bulkUploadSampleRow2Code.
  ///
  /// In en, this message translates to:
  /// **'DIV-001'**
  String get bulkUploadSampleRow2Code;

  /// No description provided for @bulkUploadSampleRow2Name.
  ///
  /// In en, this message translates to:
  /// **'Finance Division'**
  String get bulkUploadSampleRow2Name;

  /// No description provided for @bulkUploadSampleRow2NameArabic.
  ///
  /// In en, this message translates to:
  /// **'قسم المالية'**
  String get bulkUploadSampleRow2NameArabic;

  /// No description provided for @bulkUploadSampleRow2ParentCode.
  ///
  /// In en, this message translates to:
  /// **'COMP-001'**
  String get bulkUploadSampleRow2ParentCode;

  /// No description provided for @bulkUploadSampleRow2ManagerId.
  ///
  /// In en, this message translates to:
  /// **'EMP-010'**
  String get bulkUploadSampleRow2ManagerId;

  /// No description provided for @bulkUploadSampleRow2Location.
  ///
  /// In en, this message translates to:
  /// **'Kuwait City HQ'**
  String get bulkUploadSampleRow2Location;

  /// No description provided for @bulkUploadUploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload & Process'**
  String get bulkUploadUploadButton;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @searchComponents.
  ///
  /// In en, this message translates to:
  /// **'Search by name, code, or Arabic name...'**
  String get searchComponents;

  /// No description provided for @componentType.
  ///
  /// In en, this message translates to:
  /// **'Component Type'**
  String get componentType;

  /// No description provided for @componentCode.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get componentCode;

  /// No description provided for @componentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get componentName;

  /// No description provided for @arabicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Name'**
  String get arabicName;

  /// No description provided for @parentComponent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parentComponent;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @createComponent.
  ///
  /// In en, this message translates to:
  /// **'Create Component'**
  String get createComponent;

  /// No description provided for @editComponent.
  ///
  /// In en, this message translates to:
  /// **'Edit Component'**
  String get editComponent;

  /// No description provided for @viewComponent.
  ///
  /// In en, this message translates to:
  /// **'View Component'**
  String get viewComponent;

  /// No description provided for @deleteComponent.
  ///
  /// In en, this message translates to:
  /// **'Delete Component'**
  String get deleteComponent;

  /// No description provided for @treeView.
  ///
  /// In en, this message translates to:
  /// **'Tree View'**
  String get treeView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get listView;

  /// No description provided for @noComponentsFound.
  ///
  /// In en, this message translates to:
  /// **'No components found'**
  String get noComponentsFound;

  /// No description provided for @confirmDeleteComponent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this component?'**
  String get confirmDeleteComponent;

  /// No description provided for @componentTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Component type is required'**
  String get componentTypeRequired;

  /// No description provided for @componentCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Component code is required'**
  String get componentCodeRequired;

  /// No description provided for @componentNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Component name is required'**
  String get componentNameRequired;

  /// No description provided for @arabicNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Arabic name is required'**
  String get arabicNameRequired;

  /// No description provided for @selectComponentType.
  ///
  /// In en, this message translates to:
  /// **'Select component type'**
  String get selectComponentType;

  /// No description provided for @enterComponentCode.
  ///
  /// In en, this message translates to:
  /// **'Enter component code'**
  String get enterComponentCode;

  /// No description provided for @enterComponentName.
  ///
  /// In en, this message translates to:
  /// **'Enter component name'**
  String get enterComponentName;

  /// No description provided for @enterArabicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic name'**
  String get enterArabicName;

  /// No description provided for @selectParentComponent.
  ///
  /// In en, this message translates to:
  /// **'Select parent component (optional)'**
  String get selectParentComponent;

  /// No description provided for @selectManager.
  ///
  /// In en, this message translates to:
  /// **'Select manager'**
  String get selectManager;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocation;

  /// No description provided for @componentCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Component created successfully'**
  String get componentCreatedSuccessfully;

  /// No description provided for @componentUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Component updated successfully'**
  String get componentUpdatedSuccessfully;

  /// No description provided for @componentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Component deleted successfully'**
  String get componentDeletedSuccessfully;

  /// No description provided for @bulkUploadInstructions.
  ///
  /// In en, this message translates to:
  /// **'Upload a CSV file with component data. Download the template for the correct format.'**
  String get bulkUploadInstructions;

  /// No description provided for @downloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download Template'**
  String get downloadTemplate;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload successful'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @processingUpload.
  ///
  /// In en, this message translates to:
  /// **'Processing upload...'**
  String get processingUpload;

  /// No description provided for @selectComponentTypePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select type...'**
  String get selectComponentTypePlaceholder;

  /// No description provided for @componentDetails.
  ///
  /// In en, this message translates to:
  /// **'Component Details'**
  String get componentDetails;

  /// No description provided for @hierarchyRelationships.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy & Relationships'**
  String get hierarchyRelationships;

  /// No description provided for @managementInformation.
  ///
  /// In en, this message translates to:
  /// **'Management Information'**
  String get managementInformation;

  /// No description provided for @auditTrail.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get auditTrail;

  /// No description provided for @additionalFields.
  ///
  /// In en, this message translates to:
  /// **'Additional Fields'**
  String get additionalFields;

  /// No description provided for @nameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEnglish;

  /// No description provided for @nameArabic.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get nameArabic;

  /// No description provided for @costCenter.
  ///
  /// In en, this message translates to:
  /// **'Cost Center'**
  String get costCenter;

  /// No description provided for @childComponents.
  ///
  /// In en, this message translates to:
  /// **'Child Components'**
  String get childComponents;

  /// No description provided for @hierarchyPath.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Path'**
  String get hierarchyPath;

  /// No description provided for @hierarchyLevel.
  ///
  /// In en, this message translates to:
  /// **'Hierarchy Level'**
  String get hierarchyLevel;

  /// No description provided for @lastUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'Last Updated Date'**
  String get lastUpdatedDate;

  /// No description provided for @lastUpdatedBy.
  ///
  /// In en, this message translates to:
  /// **'Last Updated By'**
  String get lastUpdatedBy;

  /// No description provided for @establishedDate.
  ///
  /// In en, this message translates to:
  /// **'Established Date'**
  String get establishedDate;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get registrationNumber;

  /// No description provided for @taxId.
  ///
  /// In en, this message translates to:
  /// **'Tax Id'**
  String get taxId;

  /// No description provided for @rootLevelNoParent.
  ///
  /// In en, this message translates to:
  /// **'Root Level - No Parent'**
  String get rootLevelNoParent;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description provided'**
  String get noDescription;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @companyManagement.
  ///
  /// In en, this message translates to:
  /// **'Company Management'**
  String get companyManagement;

  /// No description provided for @manageCompanyInformation.
  ///
  /// In en, this message translates to:
  /// **'Manage company information and organizational entities'**
  String get manageCompanyInformation;

  /// No description provided for @addCompany.
  ///
  /// In en, this message translates to:
  /// **'Add Company'**
  String get addCompany;

  /// No description provided for @totalCompanies.
  ///
  /// In en, this message translates to:
  /// **'Total Companies'**
  String get totalCompanies;

  /// No description provided for @activeCompanies.
  ///
  /// In en, this message translates to:
  /// **'Active Companies'**
  String get activeCompanies;

  /// No description provided for @totalEmployees.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployees;

  /// No description provided for @compliant.
  ///
  /// In en, this message translates to:
  /// **'Compliant'**
  String get compliant;

  /// No description provided for @searchCompaniesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by company name, code, or registration number...'**
  String get searchCompaniesPlaceholder;

  /// No description provided for @editCompany.
  ///
  /// In en, this message translates to:
  /// **'Edit Company'**
  String get editCompany;

  /// No description provided for @updateCompany.
  ///
  /// In en, this message translates to:
  /// **'Update Company'**
  String get updateCompany;

  /// No description provided for @hintCompanyCode.
  ///
  /// In en, this message translates to:
  /// **'Enter company code'**
  String get hintCompanyCode;

  /// No description provided for @hintCompanyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Enter company name in English'**
  String get hintCompanyNameEnglish;

  /// No description provided for @hintCompanyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'أدخل اسم الشركة بالعربية'**
  String get hintCompanyNameArabic;

  /// No description provided for @hintLegalNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Enter legal name in English'**
  String get hintLegalNameEnglish;

  /// No description provided for @hintLegalNameArabic.
  ///
  /// In en, this message translates to:
  /// **'أدخل الاسم القانوني بالعربية'**
  String get hintLegalNameArabic;

  /// No description provided for @hintRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter registration number'**
  String get hintRegistrationNumber;

  /// No description provided for @hintTaxId.
  ///
  /// In en, this message translates to:
  /// **'Enter tax ID'**
  String get hintTaxId;

  /// No description provided for @hintEstablishedDate.
  ///
  /// In en, this message translates to:
  /// **'dd/MM/yyyy'**
  String get hintEstablishedDate;

  /// No description provided for @hintIndustry.
  ///
  /// In en, this message translates to:
  /// **'Enter industry'**
  String get hintIndustry;

  /// No description provided for @hintCountry.
  ///
  /// In en, this message translates to:
  /// **'Enter country'**
  String get hintCountry;

  /// No description provided for @hintCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get hintCity;

  /// No description provided for @hintAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter full address'**
  String get hintAddress;

  /// No description provided for @hintPoBox.
  ///
  /// In en, this message translates to:
  /// **'Enter P.O. Box'**
  String get hintPoBox;

  /// No description provided for @hintZipCode.
  ///
  /// In en, this message translates to:
  /// **'Enter zip code'**
  String get hintZipCode;

  /// No description provided for @hintPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get hintPhone;

  /// No description provided for @hintEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get hintEmail;

  /// No description provided for @hintWebsite.
  ///
  /// In en, this message translates to:
  /// **'Enter website URL'**
  String get hintWebsite;

  /// No description provided for @hintTotalEmployees.
  ///
  /// In en, this message translates to:
  /// **'Enter total employees'**
  String get hintTotalEmployees;

  /// No description provided for @hintFiscalYearStart.
  ///
  /// In en, this message translates to:
  /// **'MM-DD'**
  String get hintFiscalYearStart;

  /// No description provided for @companyDetails.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get companyDetails;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @financialAndOperational.
  ///
  /// In en, this message translates to:
  /// **'Financial & Operational'**
  String get financialAndOperational;

  /// No description provided for @established.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get established;

  /// No description provided for @divisionManagement.
  ///
  /// In en, this message translates to:
  /// **'Division Management'**
  String get divisionManagement;

  /// No description provided for @manageDivisionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage organizational divisions across companies'**
  String get manageDivisionsSubtitle;

  /// No description provided for @addDivision.
  ///
  /// In en, this message translates to:
  /// **'Add Division'**
  String get addDivision;

  /// No description provided for @totalDivisions.
  ///
  /// In en, this message translates to:
  /// **'Total Divisions'**
  String get totalDivisions;

  /// No description provided for @activeDivisions.
  ///
  /// In en, this message translates to:
  /// **'Active Divisions'**
  String get activeDivisions;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudget;

  /// No description provided for @searchDivisionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by division name, code, or head of division...'**
  String get searchDivisionsPlaceholder;

  /// No description provided for @allCompanies.
  ///
  /// In en, this message translates to:
  /// **'All Companies'**
  String get allCompanies;

  /// No description provided for @head.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get head;

  /// No description provided for @emp.
  ///
  /// In en, this message translates to:
  /// **'emp'**
  String get emp;

  /// No description provided for @depts.
  ///
  /// In en, this message translates to:
  /// **'depts'**
  String get depts;

  /// No description provided for @addNewDivision.
  ///
  /// In en, this message translates to:
  /// **'Add New Division'**
  String get addNewDivision;

  /// No description provided for @editDivision.
  ///
  /// In en, this message translates to:
  /// **'Edit Division'**
  String get editDivision;

  /// No description provided for @divisionCode.
  ///
  /// In en, this message translates to:
  /// **'Division Code'**
  String get divisionCode;

  /// No description provided for @divisionNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Division Name (English)'**
  String get divisionNameEnglish;

  /// No description provided for @divisionNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Division Name (Arabic)'**
  String get divisionNameArabic;

  /// No description provided for @headOfDivision.
  ///
  /// In en, this message translates to:
  /// **'Head of Division'**
  String get headOfDivision;

  /// No description provided for @headEmail.
  ///
  /// In en, this message translates to:
  /// **'Head Email'**
  String get headEmail;

  /// No description provided for @headPhone.
  ///
  /// In en, this message translates to:
  /// **'Head Phone'**
  String get headPhone;

  /// No description provided for @businessFocus.
  ///
  /// In en, this message translates to:
  /// **'Business Focus'**
  String get businessFocus;

  /// No description provided for @totalDepartments.
  ///
  /// In en, this message translates to:
  /// **'Total Departments'**
  String get totalDepartments;

  /// No description provided for @annualBudgetKwd.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget (KWD)'**
  String get annualBudgetKwd;

  /// No description provided for @divisionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get divisionDescription;

  /// No description provided for @createDivision.
  ///
  /// In en, this message translates to:
  /// **'Create Division'**
  String get createDivision;

  /// No description provided for @updateDivision.
  ///
  /// In en, this message translates to:
  /// **'Update Division'**
  String get updateDivision;

  /// No description provided for @selectCompany.
  ///
  /// In en, this message translates to:
  /// **'Select Company'**
  String get selectCompany;

  /// No description provided for @hintDivisionCode.
  ///
  /// In en, this message translates to:
  /// **'e.g., DIV-FIN'**
  String get hintDivisionCode;

  /// No description provided for @hintDivisionNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Division Name'**
  String get hintDivisionNameEnglish;

  /// No description provided for @hintDivisionNameArabic.
  ///
  /// In en, this message translates to:
  /// **'اسم القسم'**
  String get hintDivisionNameArabic;

  /// No description provided for @hintHeadOfDivision.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get hintHeadOfDivision;

  /// No description provided for @hintHeadEmail.
  ///
  /// In en, this message translates to:
  /// **'email@company.com'**
  String get hintHeadEmail;

  /// No description provided for @hintHeadPhone.
  ///
  /// In en, this message translates to:
  /// **'+965 XXXX XXXX'**
  String get hintHeadPhone;

  /// No description provided for @hintLocation.
  ///
  /// In en, this message translates to:
  /// **'Building/Floor'**
  String get hintLocation;

  /// No description provided for @hintBusinessFocus.
  ///
  /// In en, this message translates to:
  /// **'e.g., Financial Services'**
  String get hintBusinessFocus;

  /// No description provided for @hintTotalDepartments.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintTotalDepartments;

  /// No description provided for @hintAnnualBudgetKwd.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintAnnualBudgetKwd;

  /// No description provided for @hintDivisionDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the division\'s role and responsibilities'**
  String get hintDivisionDescription;

  /// No description provided for @divisionDetails.
  ///
  /// In en, this message translates to:
  /// **'Division Details'**
  String get divisionDetails;

  /// No description provided for @leadership.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get leadership;

  /// No description provided for @organizationalMetrics.
  ///
  /// In en, this message translates to:
  /// **'Organizational Metrics'**
  String get organizationalMetrics;

  /// No description provided for @annualBudget.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget'**
  String get annualBudget;

  /// No description provided for @businessUnitManagement.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Management'**
  String get businessUnitManagement;

  /// No description provided for @manageBusinessUnitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage business units within divisions'**
  String get manageBusinessUnitsSubtitle;

  /// No description provided for @addBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Add Business Unit'**
  String get addBusinessUnit;

  /// No description provided for @totalUnits.
  ///
  /// In en, this message translates to:
  /// **'Total Units'**
  String get totalUnits;

  /// No description provided for @activeUnits.
  ///
  /// In en, this message translates to:
  /// **'Active Units'**
  String get activeUnits;

  /// No description provided for @searchBusinessUnitsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by business unit name, code, or head...'**
  String get searchBusinessUnitsPlaceholder;

  /// No description provided for @allDivisions.
  ///
  /// In en, this message translates to:
  /// **'All Divisions'**
  String get allDivisions;

  /// No description provided for @focusArea.
  ///
  /// In en, this message translates to:
  /// **'Focus Area'**
  String get focusArea;

  /// No description provided for @unitCode.
  ///
  /// In en, this message translates to:
  /// **'Unit Code'**
  String get unitCode;

  /// No description provided for @unitNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Unit Name (English)'**
  String get unitNameEnglish;

  /// No description provided for @unitNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Unit Name (Arabic)'**
  String get unitNameArabic;

  /// No description provided for @headOfUnit.
  ///
  /// In en, this message translates to:
  /// **'Head of Unit'**
  String get headOfUnit;

  /// No description provided for @createBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Create Unit'**
  String get createBusinessUnit;

  /// No description provided for @editBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Edit Business Unit'**
  String get editBusinessUnit;

  /// No description provided for @updateBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Update Unit'**
  String get updateBusinessUnit;

  /// No description provided for @hintBusinessUnitCode.
  ///
  /// In en, this message translates to:
  /// **'e.g., BU-FIN'**
  String get hintBusinessUnitCode;

  /// No description provided for @hintBusinessUnitName.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Name'**
  String get hintBusinessUnitName;

  /// No description provided for @hintBusinessUnitNameArabic.
  ///
  /// In en, this message translates to:
  /// **'اسم الوحدة'**
  String get hintBusinessUnitNameArabic;

  /// No description provided for @hintSelectDivision.
  ///
  /// In en, this message translates to:
  /// **'Select Division'**
  String get hintSelectDivision;

  /// No description provided for @hintHeadOfUnit.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get hintHeadOfUnit;

  /// No description provided for @hintBusinessUnitHeadEmail.
  ///
  /// In en, this message translates to:
  /// **'email@company.com'**
  String get hintBusinessUnitHeadEmail;

  /// No description provided for @hintBusinessUnitHeadPhone.
  ///
  /// In en, this message translates to:
  /// **'+965 XXXX XXXX'**
  String get hintBusinessUnitHeadPhone;

  /// No description provided for @hintBusinessUnitFocus.
  ///
  /// In en, this message translates to:
  /// **'e.g., Treasury & Investments'**
  String get hintBusinessUnitFocus;

  /// No description provided for @hintBusinessUnitDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the business unit'**
  String get hintBusinessUnitDescription;

  /// No description provided for @businessUnitDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Unit Details'**
  String get businessUnitDetails;

  /// No description provided for @departmentManagement.
  ///
  /// In en, this message translates to:
  /// **'Department Management'**
  String get departmentManagement;

  /// No description provided for @manageDepartmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage departments within business units'**
  String get manageDepartmentsSubtitle;

  /// No description provided for @addDepartment.
  ///
  /// In en, this message translates to:
  /// **'Add Department'**
  String get addDepartment;

  /// No description provided for @activeDepartments.
  ///
  /// In en, this message translates to:
  /// **'Active Departments'**
  String get activeDepartments;

  /// No description provided for @totalEmployeesDept.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployeesDept;

  /// No description provided for @totalBudgetDept.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudgetDept;

  /// No description provided for @searchDepartmentsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by department name, code, or head...'**
  String get searchDepartmentsPlaceholder;

  /// No description provided for @allBusinessUnits.
  ///
  /// In en, this message translates to:
  /// **'All Business Units'**
  String get allBusinessUnits;

  /// No description provided for @departmentFocus.
  ///
  /// In en, this message translates to:
  /// **'Department Focus'**
  String get departmentFocus;

  /// No description provided for @departmentCode.
  ///
  /// In en, this message translates to:
  /// **'Department Code'**
  String get departmentCode;

  /// No description provided for @departmentNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Department Name (English)'**
  String get departmentNameEnglish;

  /// No description provided for @departmentNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Department Name (Arabic)'**
  String get departmentNameArabic;

  /// No description provided for @headOfDepartment.
  ///
  /// In en, this message translates to:
  /// **'Head of Department'**
  String get headOfDepartment;

  /// No description provided for @hintDepartmentCode.
  ///
  /// In en, this message translates to:
  /// **'e.g., DEPT-TREAS'**
  String get hintDepartmentCode;

  /// No description provided for @hintDepartmentNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get hintDepartmentNameEnglish;

  /// No description provided for @hintDepartmentNameArabic.
  ///
  /// In en, this message translates to:
  /// **'اسم القسم'**
  String get hintDepartmentNameArabic;

  /// No description provided for @hintBusinessUnit.
  ///
  /// In en, this message translates to:
  /// **'Select Business Unit'**
  String get hintBusinessUnit;

  /// No description provided for @hintHeadOfDepartment.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get hintHeadOfDepartment;

  /// No description provided for @hintAnnualBudgetDepartment.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get hintAnnualBudgetDepartment;

  /// No description provided for @hintDescriptionDepartment.
  ///
  /// In en, this message translates to:
  /// **'Brief description of the department'**
  String get hintDescriptionDepartment;

  /// No description provided for @editDepartment.
  ///
  /// In en, this message translates to:
  /// **'Edit Department'**
  String get editDepartment;

  /// No description provided for @updateDepartment.
  ///
  /// In en, this message translates to:
  /// **'Update Department'**
  String get updateDepartment;

  /// No description provided for @departmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Department Details'**
  String get departmentDetails;

  /// No description provided for @departmentLeadership.
  ///
  /// In en, this message translates to:
  /// **'Department Leadership'**
  String get departmentLeadership;

  /// No description provided for @departmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Department Description'**
  String get departmentDescription;

  /// No description provided for @departmentBudget.
  ///
  /// In en, this message translates to:
  /// **'Annual Budget (KWD)'**
  String get departmentBudget;

  /// No description provided for @sectionManagement.
  ///
  /// In en, this message translates to:
  /// **'Section Management'**
  String get sectionManagement;

  /// No description provided for @manageSectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize and manage organizational sections'**
  String get manageSectionsSubtitle;

  /// No description provided for @addSection.
  ///
  /// In en, this message translates to:
  /// **'Add Section'**
  String get addSection;

  /// No description provided for @editSection.
  ///
  /// In en, this message translates to:
  /// **'Edit Section'**
  String get editSection;

  /// No description provided for @updateSection.
  ///
  /// In en, this message translates to:
  /// **'Update Section'**
  String get updateSection;

  /// No description provided for @sectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Section Details'**
  String get sectionDetails;

  /// No description provided for @totalSections.
  ///
  /// In en, this message translates to:
  /// **'Total Sections'**
  String get totalSections;

  /// No description provided for @activeSections.
  ///
  /// In en, this message translates to:
  /// **'Active Sections'**
  String get activeSections;

  /// No description provided for @totalEmployeesSection.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployeesSection;

  /// No description provided for @totalBudgetSection.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudgetSection;

  /// No description provided for @searchSectionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search sections...'**
  String get searchSectionsPlaceholder;

  /// No description provided for @managePositionsJobFamilies.
  ///
  /// In en, this message translates to:
  /// **'Manage positions, job families, levels, and organizational structure'**
  String get managePositionsJobFamilies;

  /// No description provided for @managePositionsJobFamiliesAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة الوظائف والعائلات الوظيفية والمستويات والهيكل التنظيمي'**
  String get managePositionsJobFamiliesAr;

  /// No description provided for @totalPositions.
  ///
  /// In en, this message translates to:
  /// **'Total Positions'**
  String get totalPositions;

  /// No description provided for @filledPositions.
  ///
  /// In en, this message translates to:
  /// **'Filled Positions'**
  String get filledPositions;

  /// No description provided for @vacantPositions.
  ///
  /// In en, this message translates to:
  /// **'Vacant Positions'**
  String get vacantPositions;

  /// No description provided for @fillRate.
  ///
  /// In en, this message translates to:
  /// **'Fill Rate'**
  String get fillRate;

  /// No description provided for @positions.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get positions;

  /// No description provided for @jobFamilies.
  ///
  /// In en, this message translates to:
  /// **'Job Families'**
  String get jobFamilies;

  /// No description provided for @addJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Add Job Family'**
  String get addJobFamily;

  /// No description provided for @jobLevels.
  ///
  /// In en, this message translates to:
  /// **'Job Levels'**
  String get jobLevels;

  /// No description provided for @jobFamilyOverview.
  ///
  /// In en, this message translates to:
  /// **'Job Family Overview'**
  String get jobFamilyOverview;

  /// No description provided for @jobFamilyStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get jobFamilyStatus;

  /// No description provided for @positionsByLevel.
  ///
  /// In en, this message translates to:
  /// **'Positions By Level'**
  String get positionsByLevel;

  /// No description provided for @jobFamilyCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get jobFamilyCreated;

  /// No description provided for @jobFamilyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get jobFamilyUpdated;

  /// No description provided for @noDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No job level data is available for this family.'**
  String get noDataMessage;

  /// No description provided for @jobFamilyDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Family Details'**
  String get jobFamilyDetails;

  /// No description provided for @jobLevelDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Level Details'**
  String get jobLevelDetails;

  /// No description provided for @talentStatus.
  ///
  /// In en, this message translates to:
  /// **'Talent Status'**
  String get talentStatus;

  /// No description provided for @jobLevelCode.
  ///
  /// In en, this message translates to:
  /// **'Level Code'**
  String get jobLevelCode;

  /// No description provided for @salaryRangeSection.
  ///
  /// In en, this message translates to:
  /// **'Salary Range'**
  String get salaryRangeSection;

  /// No description provided for @minimumSalary.
  ///
  /// In en, this message translates to:
  /// **'Minimum Salary'**
  String get minimumSalary;

  /// No description provided for @maximumSalary.
  ///
  /// In en, this message translates to:
  /// **'Maximum Salary'**
  String get maximumSalary;

  /// No description provided for @medianSalary.
  ///
  /// In en, this message translates to:
  /// **'Median Salary'**
  String get medianSalary;

  /// No description provided for @keyResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'Key Responsibilities'**
  String get keyResponsibilities;

  /// No description provided for @progressionPath.
  ///
  /// In en, this message translates to:
  /// **'Progression Path'**
  String get progressionPath;

  /// No description provided for @averageTenure.
  ///
  /// In en, this message translates to:
  /// **'Average Tenure'**
  String get averageTenure;

  /// No description provided for @positionStatistics.
  ///
  /// In en, this message translates to:
  /// **'Position Statistics'**
  String get positionStatistics;

  /// No description provided for @enterNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Enter English name'**
  String get enterNameEnglish;

  /// No description provided for @enterNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic name'**
  String get enterNameArabic;

  /// No description provided for @positionFamilyDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get positionFamilyDescription;

  /// No description provided for @addNewJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Add New Job Family'**
  String get addNewJobFamily;

  /// No description provided for @jobFamilyCode.
  ///
  /// In en, this message translates to:
  /// **'Job Family Code'**
  String get jobFamilyCode;

  /// No description provided for @jobFamilyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., JF-001'**
  String get jobFamilyCodeHint;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @autoGenerated.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated'**
  String get autoGenerated;

  /// No description provided for @jobFamilyNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Job Family Name (English)'**
  String get jobFamilyNameEnglish;

  /// No description provided for @jobFamilyNameEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Finance & Accounting'**
  String get jobFamilyNameEnglishHint;

  /// No description provided for @jobFamilyNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Job Family Name (Arabic)'**
  String get jobFamilyNameArabic;

  /// No description provided for @jobFamilyNameArabicHint.
  ///
  /// In en, this message translates to:
  /// **'مثال: المالية والمحاسبة'**
  String get jobFamilyNameArabicHint;

  /// No description provided for @createJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Create Job Family'**
  String get createJobFamily;

  /// No description provided for @editJobFamily.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Family'**
  String get editJobFamily;

  /// No description provided for @addNewJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Add New Job Level'**
  String get addNewJobLevel;

  /// No description provided for @editJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Edit Job Level'**
  String get editJobLevel;

  /// No description provided for @levelName.
  ///
  /// In en, this message translates to:
  /// **'Level Name'**
  String get levelName;

  /// No description provided for @levelNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Executive'**
  String get levelNameHint;

  /// No description provided for @jobLevelDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the level'**
  String get jobLevelDescriptionHint;

  /// No description provided for @gradeRange.
  ///
  /// In en, this message translates to:
  /// **'Grade Range'**
  String get gradeRange;

  /// No description provided for @gradeRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Grade X - Grade Y'**
  String get gradeRangeHint;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @defaultJobFamily.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get defaultJobFamily;

  /// No description provided for @createJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Create Job Level'**
  String get createJobLevel;

  /// No description provided for @jobLevelCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., EXEC'**
  String get jobLevelCodeHint;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @minimumGrade.
  ///
  /// In en, this message translates to:
  /// **'Minimum Grade'**
  String get minimumGrade;

  /// No description provided for @maximumGrade.
  ///
  /// In en, this message translates to:
  /// **'Maximum Grade'**
  String get maximumGrade;

  /// No description provided for @gradeStructure.
  ///
  /// In en, this message translates to:
  /// **'Grade & Step Structure'**
  String get gradeStructure;

  /// No description provided for @reportingStructure.
  ///
  /// In en, this message translates to:
  /// **'Reporting Structure'**
  String get reportingStructure;

  /// No description provided for @positionTree.
  ///
  /// In en, this message translates to:
  /// **'Position Tree'**
  String get positionTree;

  /// No description provided for @addPosition.
  ///
  /// In en, this message translates to:
  /// **'Add Position'**
  String get addPosition;

  /// No description provided for @editPosition.
  ///
  /// In en, this message translates to:
  /// **'Edit Position'**
  String get editPosition;

  /// No description provided for @addJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Add Job Level'**
  String get addJobLevel;

  /// No description provided for @addGrade.
  ///
  /// In en, this message translates to:
  /// **'Add Grade'**
  String get addGrade;

  /// No description provided for @createGrade.
  ///
  /// In en, this message translates to:
  /// **'Create Grade'**
  String get createGrade;

  /// No description provided for @editGrade.
  ///
  /// In en, this message translates to:
  /// **'Edit Grade'**
  String get editGrade;

  /// No description provided for @gradeName.
  ///
  /// In en, this message translates to:
  /// **'Grade Name'**
  String get gradeName;

  /// No description provided for @gradeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Grade A'**
  String get gradeNameHint;

  /// No description provided for @gradeDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter grade description'**
  String get gradeDescriptionHint;

  /// No description provided for @gradeSteps.
  ///
  /// In en, this message translates to:
  /// **'Grade Steps'**
  String get gradeSteps;

  /// No description provided for @gradeStepLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get gradeStepLabelHint;

  /// No description provided for @gradeStepAmountHint.
  ///
  /// In en, this message translates to:
  /// **'SAR 5,000'**
  String get gradeStepAmountHint;

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get addStep;

  /// No description provided for @gradeNumber.
  ///
  /// In en, this message translates to:
  /// **'Grade Number'**
  String get gradeNumber;

  /// No description provided for @selectGrade.
  ///
  /// In en, this message translates to:
  /// **'Select Grade'**
  String get selectGrade;

  /// No description provided for @gradeCategory.
  ///
  /// In en, this message translates to:
  /// **'Grade Category'**
  String get gradeCategory;

  /// No description provided for @entryLevel.
  ///
  /// In en, this message translates to:
  /// **'Entry Level'**
  String get entryLevel;

  /// No description provided for @stepSalaryStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Step Salary Structure'**
  String get stepSalaryStructureTitle;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @kdSymbol.
  ///
  /// In en, this message translates to:
  /// **'KD'**
  String get kdSymbol;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @searchPositionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search positions by title, code, or Arabic name...'**
  String get searchPositionsPlaceholder;

  /// No description provided for @allDepartments.
  ///
  /// In en, this message translates to:
  /// **'All Departments'**
  String get allDepartments;

  /// No description provided for @positionCode.
  ///
  /// In en, this message translates to:
  /// **'Position Code'**
  String get positionCode;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @jobFamily.
  ///
  /// In en, this message translates to:
  /// **'Job Family'**
  String get jobFamily;

  /// No description provided for @jobLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get jobLevel;

  /// No description provided for @gradeStep.
  ///
  /// In en, this message translates to:
  /// **'Grade/Step'**
  String get gradeStep;

  /// No description provided for @reportsTo.
  ///
  /// In en, this message translates to:
  /// **'Reports To'**
  String get reportsTo;

  /// No description provided for @headcount.
  ///
  /// In en, this message translates to:
  /// **'Headcount'**
  String get headcount;

  /// No description provided for @vacancy.
  ///
  /// In en, this message translates to:
  /// **'Vacancy'**
  String get vacancy;

  /// No description provided for @vacant.
  ///
  /// In en, this message translates to:
  /// **'vacant'**
  String get vacant;

  /// No description provided for @filled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @titleEnglish.
  ///
  /// In en, this message translates to:
  /// **'Title (English)'**
  String get titleEnglish;

  /// No description provided for @titleArabic.
  ///
  /// In en, this message translates to:
  /// **'Title (Arabic)'**
  String get titleArabic;

  /// No description provided for @reportingStructureDescription.
  ///
  /// In en, this message translates to:
  /// **'Tabular view of position reporting relationships and hierarchy'**
  String get reportingStructureDescription;

  /// No description provided for @reportingStructureDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'عرض جدولي لهيكل التقارير والتسلسل الوظيفي'**
  String get reportingStructureDescriptionAr;

  /// No description provided for @exportTable.
  ///
  /// In en, this message translates to:
  /// **'Export Table'**
  String get exportTable;

  /// No description provided for @withReports.
  ///
  /// In en, this message translates to:
  /// **'With Reports'**
  String get withReports;

  /// No description provided for @positionTitle.
  ///
  /// In en, this message translates to:
  /// **'Position Title'**
  String get positionTitle;

  /// No description provided for @directReports.
  ///
  /// In en, this message translates to:
  /// **'Direct Reports'**
  String get directReports;

  /// No description provided for @noReports.
  ///
  /// In en, this message translates to:
  /// **'No reports'**
  String get noReports;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// No description provided for @positionTypes.
  ///
  /// In en, this message translates to:
  /// **'Position Types'**
  String get positionTypes;

  /// No description provided for @topLevelPositions.
  ///
  /// In en, this message translates to:
  /// **'Top Level Positions'**
  String get topLevelPositions;

  /// No description provided for @noReportingManager.
  ///
  /// In en, this message translates to:
  /// **'No reporting manager'**
  String get noReportingManager;

  /// No description provided for @managementPositions.
  ///
  /// In en, this message translates to:
  /// **'Management Positions'**
  String get managementPositions;

  /// No description provided for @hasDirectReports.
  ///
  /// In en, this message translates to:
  /// **'Has direct reports'**
  String get hasDirectReports;

  /// No description provided for @individualContributors.
  ///
  /// In en, this message translates to:
  /// **'Individual Contributors'**
  String get individualContributors;

  /// No description provided for @noDirectReports.
  ///
  /// In en, this message translates to:
  /// **'No direct reports'**
  String get noDirectReports;

  /// No description provided for @positionDetails.
  ///
  /// In en, this message translates to:
  /// **'Position Details'**
  String get positionDetails;

  /// No description provided for @organizationalInformation.
  ///
  /// In en, this message translates to:
  /// **'Organizational Information'**
  String get organizationalInformation;

  /// No description provided for @jobClassification.
  ///
  /// In en, this message translates to:
  /// **'Job Classification'**
  String get jobClassification;

  /// No description provided for @headcountInformation.
  ///
  /// In en, this message translates to:
  /// **'Headcount Information'**
  String get headcountInformation;

  /// No description provided for @salaryInformation.
  ///
  /// In en, this message translates to:
  /// **'Salary Information'**
  String get salaryInformation;

  /// No description provided for @reportingRelationship.
  ///
  /// In en, this message translates to:
  /// **'Reporting Relationship'**
  String get reportingRelationship;

  /// No description provided for @employmentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get employmentType;

  /// No description provided for @budgetedMin.
  ///
  /// In en, this message translates to:
  /// **'Budgeted Min'**
  String get budgetedMin;

  /// No description provided for @budgetedMax.
  ///
  /// In en, this message translates to:
  /// **'Budgeted Max'**
  String get budgetedMax;

  /// No description provided for @actualAverage.
  ///
  /// In en, this message translates to:
  /// **'Actual Average'**
  String get actualAverage;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @deleteJobLevel.
  ///
  /// In en, this message translates to:
  /// **'Delete Job Level'**
  String get deleteJobLevel;

  /// No description provided for @deleteJobLevelConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this job level? This action cannot be undone.'**
  String get deleteJobLevelConfirmationMessage;

  /// No description provided for @jobLevelCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job level created successfully'**
  String get jobLevelCreatedSuccessfully;

  /// No description provided for @jobLevelUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job level updated successfully'**
  String get jobLevelUpdatedSuccessfully;

  /// No description provided for @jobLevelDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Job level deleted successfully'**
  String get jobLevelDeletedSuccessfully;

  /// No description provided for @errorCreatingJobLevel.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while creating the job level'**
  String get errorCreatingJobLevel;

  /// No description provided for @errorDeletingJobLevel.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while deleting the job level'**
  String get errorDeletingJobLevel;

  /// No description provided for @timeManagementTitle.
  ///
  /// In en, this message translates to:
  /// **'Time Management'**
  String get timeManagementTitle;

  /// No description provided for @tmAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get tmAttendance;

  /// No description provided for @tmLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get tmLate;

  /// No description provided for @tmOvertime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get tmOvertime;

  /// No description provided for @tmAbsences.
  ///
  /// In en, this message translates to:
  /// **'Absences'**
  String get tmAbsences;

  /// No description provided for @tmPendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending Approvals'**
  String get tmPendingApprovals;

  /// No description provided for @tmCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get tmCheckIn;

  /// No description provided for @tmCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get tmCheckOut;

  /// No description provided for @tmRequestLeave.
  ///
  /// In en, this message translates to:
  /// **'Request Leave'**
  String get tmRequestLeave;

  /// No description provided for @tmAssignSchedule.
  ///
  /// In en, this message translates to:
  /// **'Assign Schedule'**
  String get tmAssignSchedule;

  /// No description provided for @tmApprovals.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get tmApprovals;

  /// No description provided for @tmOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tmOverview;

  /// No description provided for @tmSchedules.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get tmSchedules;

  /// No description provided for @tmRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get tmRequests;

  /// No description provided for @tmEmployee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get tmEmployee;

  /// No description provided for @tmType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get tmType;

  /// No description provided for @tmDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get tmDate;

  /// No description provided for @tmDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get tmDuration;

  /// No description provided for @tmStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tmStatus;

  /// No description provided for @tmAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get tmAction;

  /// No description provided for @tmSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by employee, type...'**
  String get tmSearchPlaceholder;

  /// No description provided for @tmFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get tmFilterAll;

  /// No description provided for @tmFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tmFilterPending;

  /// No description provided for @tmFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get tmFilterApproved;

  /// No description provided for @tmFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get tmFilterRejected;

  /// No description provided for @manageShiftsWorkPatterns.
  ///
  /// In en, this message translates to:
  /// **'Manage shifts, work patterns, schedules, and assignments'**
  String get manageShiftsWorkPatterns;

  /// No description provided for @manageShiftsWorkPatternsAr.
  ///
  /// In en, this message translates to:
  /// **'إدارة الورديات وأنماط العمل والجداول والتعيينات'**
  String get manageShiftsWorkPatternsAr;

  /// No description provided for @shifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shifts;

  /// No description provided for @workPatterns.
  ///
  /// In en, this message translates to:
  /// **'Work Patterns'**
  String get workPatterns;

  /// No description provided for @addWorkPattern.
  ///
  /// In en, this message translates to:
  /// **'Add Work Pattern'**
  String get addWorkPattern;

  /// No description provided for @createWorkPattern.
  ///
  /// In en, this message translates to:
  /// **'Create Work Pattern'**
  String get createWorkPattern;

  /// No description provided for @workSchedules.
  ///
  /// In en, this message translates to:
  /// **'Work Schedules'**
  String get workSchedules;

  /// No description provided for @createWorkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create Schedule'**
  String get createWorkSchedule;

  /// No description provided for @scheduleAssignments.
  ///
  /// In en, this message translates to:
  /// **'Schedule Assignments'**
  String get scheduleAssignments;

  /// No description provided for @viewCalendar.
  ///
  /// In en, this message translates to:
  /// **'View Calendar'**
  String get viewCalendar;

  /// No description provided for @publicHolidays.
  ///
  /// In en, this message translates to:
  /// **'Public Holidays'**
  String get publicHolidays;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// No description provided for @deleteStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Organization Structure'**
  String get deleteStructureTitle;

  /// No description provided for @cascadeDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently delete the organization structure and all associated organizational units.'**
  String get cascadeDeleteWarning;

  /// No description provided for @cascadeDeleteDetails.
  ///
  /// In en, this message translates to:
  /// **'The structure \"{structureName}\" has {orgUnitsCount} organizational unit(s) that will be deleted. This action cannot be undone.'**
  String cascadeDeleteDetails(String structureName, int orgUnitsCount);

  /// No description provided for @deleteStructureMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to proceed?'**
  String get deleteStructureMessage;

  /// No description provided for @structureReferencedError.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete organization structure: This structure is referenced by other records in the database.'**
  String get structureReferencedError;

  /// No description provided for @structureDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Organization structure deleted successfully.'**
  String get structureDeletedSuccess;

  /// No description provided for @confirmDeleteStructure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this structure?'**
  String get confirmDeleteStructure;

  /// No description provided for @structureHasOrgUnits.
  ///
  /// In en, this message translates to:
  /// **'This structure has {count} organizational unit(s) that reference it. You must delete all organizational units first, or use cascade delete.'**
  String structureHasOrgUnits(int count);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @leaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Leave Requests'**
  String get leaveRequests;

  /// No description provided for @leaveRequestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Submit and approve requests'**
  String get leaveRequestsDescription;

  /// No description provided for @leaveBalance.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leaveBalance;

  /// No description provided for @leaveBalanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Employee leave balances'**
  String get leaveBalanceDescription;

  /// No description provided for @myLeaveBalance.
  ///
  /// In en, this message translates to:
  /// **'My Leave Balance'**
  String get myLeaveBalance;

  /// No description provided for @myLeaveBalanceDescription.
  ///
  /// In en, this message translates to:
  /// **'View your leave balances, carry forward, and forfeit information'**
  String get myLeaveBalanceDescription;

  /// No description provided for @applyLeave.
  ///
  /// In en, this message translates to:
  /// **'Apply Leave'**
  String get applyLeave;

  /// No description provided for @requestEncashment.
  ///
  /// In en, this message translates to:
  /// **'Request Encashment'**
  String get requestEncashment;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @employeeNumber.
  ///
  /// In en, this message translates to:
  /// **'Employee Number'**
  String get employeeNumber;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @daysAvailable.
  ///
  /// In en, this message translates to:
  /// **'days available'**
  String get daysAvailable;

  /// No description provided for @currentYear.
  ///
  /// In en, this message translates to:
  /// **'Current Year'**
  String get currentYear;

  /// No description provided for @carriedForward.
  ///
  /// In en, this message translates to:
  /// **'Carried Forward'**
  String get carriedForward;

  /// No description provided for @carryForwardAllowed.
  ///
  /// In en, this message translates to:
  /// **'Carry Forward Allowed'**
  String get carryForwardAllowed;

  /// No description provided for @atRisk.
  ///
  /// In en, this message translates to:
  /// **'At Risk'**
  String get atRisk;

  /// No description provided for @atRiskForfeitable.
  ///
  /// In en, this message translates to:
  /// **'At-Risk (Forfeitable)'**
  String get atRiskForfeitable;

  /// No description provided for @encashmentAvailable.
  ///
  /// In en, this message translates to:
  /// **'Encashment Available'**
  String get encashmentAvailable;

  /// No description provided for @requestEncashmentButton.
  ///
  /// In en, this message translates to:
  /// **'Request →'**
  String get requestEncashmentButton;

  /// No description provided for @encashmentDescription.
  ///
  /// In en, this message translates to:
  /// **'You can request to encash unused leave days for monetary compensation'**
  String get encashmentDescription;

  /// No description provided for @atRiskDescription.
  ///
  /// In en, this message translates to:
  /// **'These days exceed the carry forward limit and will be forfeited after {date}'**
  String atRiskDescription(String date);

  /// No description provided for @hajjLeave.
  ///
  /// In en, this message translates to:
  /// **'Hajj Leave'**
  String get hajjLeave;

  /// No description provided for @hajjLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'إجازة الحج'**
  String get hajjLeaveArabic;

  /// No description provided for @compassionateLeave.
  ///
  /// In en, this message translates to:
  /// **'Compassionate Leave'**
  String get compassionateLeave;

  /// No description provided for @compassionateLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'إجازة خاصة'**
  String get compassionateLeaveArabic;

  /// No description provided for @annualLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'الإجازة السنوية'**
  String get annualLeaveArabic;

  /// No description provided for @sickLeaveArabic.
  ///
  /// In en, this message translates to:
  /// **'الإجازة المرضية'**
  String get sickLeaveArabic;

  /// No description provided for @kuwaitLaborLawLeavePolicy.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law Leave Policy'**
  String get kuwaitLaborLawLeavePolicy;

  /// No description provided for @carryForwardPolicy.
  ///
  /// In en, this message translates to:
  /// **'Carry Forward'**
  String get carryForwardPolicy;

  /// No description provided for @carryForwardPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Annual leave can be carried forward subject to Kuwait Labor Law regulations and company policy limits'**
  String get carryForwardPolicyDescription;

  /// No description provided for @forfeitRules.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Rules'**
  String get forfeitRules;

  /// No description provided for @forfeitRulesDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave days exceeding carry forward limits will be forfeited at the end of the grace period'**
  String get forfeitRulesDescription;

  /// No description provided for @encashmentPolicy.
  ///
  /// In en, this message translates to:
  /// **'Encashment'**
  String get encashmentPolicy;

  /// No description provided for @encashmentPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Eligible leave types can be encashed subject to manager approval and company policy'**
  String get encashmentPolicyDescription;

  /// No description provided for @teamLeaveRiskDescription.
  ///
  /// In en, this message translates to:
  /// **'Team absence risk analysis'**
  String get teamLeaveRiskDescription;

  /// No description provided for @leavePolicies.
  ///
  /// In en, this message translates to:
  /// **'Leave Policies'**
  String get leavePolicies;

  /// No description provided for @leavePoliciesDescription.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law policies'**
  String get leavePoliciesDescription;

  /// No description provided for @policyConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Policy Configuration'**
  String get policyConfiguration;

  /// No description provided for @policyConfigurationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure leave eligibility'**
  String get policyConfigurationDescription;

  /// No description provided for @forfeitPolicy.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Policy'**
  String get forfeitPolicy;

  /// No description provided for @forfeitPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave forfeit rules'**
  String get forfeitPolicyDescription;

  /// No description provided for @forfeitProcessing.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Processing'**
  String get forfeitProcessing;

  /// No description provided for @forfeitProcessingDescription.
  ///
  /// In en, this message translates to:
  /// **'Process leave forfeits'**
  String get forfeitProcessingDescription;

  /// No description provided for @forfeitReports.
  ///
  /// In en, this message translates to:
  /// **'Forfeit Reports'**
  String get forfeitReports;

  /// No description provided for @forfeitReportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Forfeit analytics'**
  String get forfeitReportsDescription;

  /// No description provided for @leaveCalendar.
  ///
  /// In en, this message translates to:
  /// **'Leave Calendar'**
  String get leaveCalendar;

  /// No description provided for @leaveCalendarDescription.
  ///
  /// In en, this message translates to:
  /// **'Team absence calendar'**
  String get leaveCalendarDescription;

  /// No description provided for @manageEmployeeLeaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Manage employee leave requests according to Kuwait Labor Law'**
  String get manageEmployeeLeaveRequests;

  /// No description provided for @newLeaveRequest.
  ///
  /// In en, this message translates to:
  /// **'New Leave Request'**
  String get newLeaveRequest;

  /// No description provided for @kuwaitLaborLawLeaveEntitlements.
  ///
  /// In en, this message translates to:
  /// **'Kuwait Labor Law Leave Entitlements'**
  String get kuwaitLaborLawLeaveEntitlements;

  /// No description provided for @annualLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'30 days per year after 1 year of service'**
  String get annualLeaveEntitlement;

  /// No description provided for @sickLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'15 days full pay + 10 days half pay + 10 days unpaid'**
  String get sickLeaveEntitlement;

  /// No description provided for @maternityLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'70 days total (30 before, 40 after delivery)'**
  String get maternityLeaveEntitlement;

  /// No description provided for @emergencyLeaveEntitlement.
  ///
  /// In en, this message translates to:
  /// **'5 days per year for emergencies'**
  String get emergencyLeaveEntitlement;

  /// No description provided for @leaveFilterAll.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get leaveFilterAll;

  /// No description provided for @leaveFilterPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get leaveFilterPending;

  /// No description provided for @leaveFilterApproved.
  ///
  /// In en, this message translates to:
  /// **'approved'**
  String get leaveFilterApproved;

  /// No description provided for @leaveFilterRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get leaveFilterRejected;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @leaveType.
  ///
  /// In en, this message translates to:
  /// **'Leave Type'**
  String get leaveType;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @maternityLeave.
  ///
  /// In en, this message translates to:
  /// **'Maternity Leave'**
  String get maternityLeave;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @leaveRequestGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Leave Request Guidelines'**
  String get leaveRequestGuidelines;

  /// No description provided for @submitRequests3DaysAdvance.
  ///
  /// In en, this message translates to:
  /// **'• Submit requests at least 3 days in advance for annual leave'**
  String get submitRequests3DaysAdvance;

  /// No description provided for @sickLeaveRequiresCertificate.
  ///
  /// In en, this message translates to:
  /// **'• Sick leave requires medical certificate if more than 3 days'**
  String get sickLeaveRequiresCertificate;

  /// No description provided for @ensureWorkHandover.
  ///
  /// In en, this message translates to:
  /// **'• Ensure work handover is completed before leave starts'**
  String get ensureWorkHandover;

  /// No description provided for @typeToSearchEmployees.
  ///
  /// In en, this message translates to:
  /// **'Type to search employees...'**
  String get typeToSearchEmployees;

  /// No description provided for @leaveTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Leave Type *'**
  String get leaveTypeRequired;

  /// No description provided for @annualLeavePaidVacation.
  ///
  /// In en, this message translates to:
  /// **'Annual Leave (Paid Vacation)'**
  String get annualLeavePaidVacation;

  /// No description provided for @regularPaidVacationLeave.
  ///
  /// In en, this message translates to:
  /// **'Regular paid vacation leave'**
  String get regularPaidVacationLeave;

  /// No description provided for @maximum30DaysPerYear.
  ///
  /// In en, this message translates to:
  /// **'Maximum: 30 days per year'**
  String get maximum30DaysPerYear;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @fullDay.
  ///
  /// In en, this message translates to:
  /// **'Full Day'**
  String get fullDay;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @completeAllStepsToSubmit.
  ///
  /// In en, this message translates to:
  /// **'Complete all steps to submit your leave application'**
  String get completeAllStepsToSubmit;

  /// No description provided for @leaveDetails.
  ///
  /// In en, this message translates to:
  /// **'Leave Details'**
  String get leaveDetails;

  /// No description provided for @contactNotes.
  ///
  /// In en, this message translates to:
  /// **'Contact & Notes'**
  String get contactNotes;

  /// No description provided for @documentsReview.
  ///
  /// In en, this message translates to:
  /// **'Documents & Review'**
  String get documentsReview;

  /// No description provided for @reasonForLeave.
  ///
  /// In en, this message translates to:
  /// **'Reason for Leave *'**
  String get reasonForLeave;

  /// No description provided for @pleaseProvideDetailedReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a detailed reason for your leave request...'**
  String get pleaseProvideDetailedReason;

  /// No description provided for @charactersCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/500 characters'**
  String charactersCount(int count);

  /// No description provided for @workDelegatedTo.
  ///
  /// In en, this message translates to:
  /// **'Work Delegated To'**
  String get workDelegatedTo;

  /// No description provided for @selectColleagueToHandleWork.
  ///
  /// In en, this message translates to:
  /// **'Select colleague to handle your work...'**
  String get selectColleagueToHandleWork;

  /// No description provided for @selectColleagueWhoWillHandle.
  ///
  /// In en, this message translates to:
  /// **'Select a colleague who will handle your responsibilities during your absence'**
  String get selectColleagueWhoWillHandle;

  /// No description provided for @contactInformationDuringLeave.
  ///
  /// In en, this message translates to:
  /// **'Contact Information During Leave'**
  String get contactInformationDuringLeave;

  /// No description provided for @addressDuringLeave.
  ///
  /// In en, this message translates to:
  /// **'Address During Leave'**
  String get addressDuringLeave;

  /// No description provided for @enterAddressOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your address or location during leave...'**
  String get enterAddressOrLocation;

  /// No description provided for @contactPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone Number'**
  String get contactPhoneNumber;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Name'**
  String get emergencyContactName;

  /// No description provided for @enterEmergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter emergency contact name'**
  String get enterEmergencyContactName;

  /// No description provided for @emergencyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Phone'**
  String get emergencyContactPhone;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @anyAdditionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Any additional information or special considerations...'**
  String get anyAdditionalInformation;

  /// No description provided for @supportingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Supporting Documents'**
  String get supportingDocuments;

  /// No description provided for @clickToUploadOrDragDrop.
  ///
  /// In en, this message translates to:
  /// **'Click to upload or drag and drop'**
  String get clickToUploadOrDragDrop;

  /// No description provided for @pdfDocDocxJpgPngUpTo10MB.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOC, DOCX, JPG, PNG up to 10MB each'**
  String get pdfDocDocxJpgPngUpTo10MB;

  /// No description provided for @requiredDocuments.
  ///
  /// In en, this message translates to:
  /// **'Required Documents:'**
  String get requiredDocuments;

  /// No description provided for @supportingDocumentsIfApplicable.
  ///
  /// In en, this message translates to:
  /// **'• Supporting documents (if applicable)'**
  String get supportingDocumentsIfApplicable;

  /// No description provided for @requestSummary.
  ///
  /// In en, this message translates to:
  /// **'Request Summary'**
  String get requestSummary;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @filesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s)'**
  String filesCount(int count);

  /// No description provided for @declaration.
  ///
  /// In en, this message translates to:
  /// **'Declaration'**
  String get declaration;

  /// No description provided for @declarationText.
  ///
  /// In en, this message translates to:
  /// **'By submitting this leave request, I confirm that all information provided is accurate and complete. I understand that providing false information may result in disciplinary action. I have completed necessary work handover and informed relevant parties about my absence.'**
  String get declarationText;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @teamLeaveRisk.
  ///
  /// In en, this message translates to:
  /// **'Team Leave Risk'**
  String get teamLeaveRisk;

  /// No description provided for @teamLeaveRiskDashboard.
  ///
  /// In en, this message translates to:
  /// **'Team Leave Risk Dashboard'**
  String get teamLeaveRiskDashboard;

  /// No description provided for @monitorAndManageTeamMembersAtRisk.
  ///
  /// In en, this message translates to:
  /// **'Monitor and manage team members at risk of leave forfeit'**
  String get monitorAndManageTeamMembersAtRisk;

  /// No description provided for @teamMembers.
  ///
  /// In en, this message translates to:
  /// **'Team Members'**
  String get teamMembers;

  /// No description provided for @activeEmployees.
  ///
  /// In en, this message translates to:
  /// **'Active employees'**
  String get activeEmployees;

  /// No description provided for @employeesAtRisk.
  ///
  /// In en, this message translates to:
  /// **'Employees at Risk'**
  String get employeesAtRisk;

  /// No description provided for @totalAtRiskDays.
  ///
  /// In en, this message translates to:
  /// **'Total At-Risk Days'**
  String get totalAtRiskDays;

  /// No description provided for @acrossAllTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Across all team members'**
  String get acrossAllTeamMembers;

  /// No description provided for @avgAtRiskPerEmployee.
  ///
  /// In en, this message translates to:
  /// **'Avg At-Risk per Employee'**
  String get avgAtRiskPerEmployee;

  /// No description provided for @daysPerEmployee.
  ///
  /// In en, this message translates to:
  /// **'Days per employee'**
  String get daysPerEmployee;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @allLeaveTypes.
  ///
  /// In en, this message translates to:
  /// **'All Leave Types'**
  String get allLeaveTypes;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @employeesWithAtRiskLeave.
  ///
  /// In en, this message translates to:
  /// **'Employees with At-Risk Leave'**
  String get employeesWithAtRiskLeave;

  /// No description provided for @atRiskDays.
  ///
  /// In en, this message translates to:
  /// **'At-Risk Days'**
  String get atRiskDays;

  /// No description provided for @carryForwardLimit.
  ///
  /// In en, this message translates to:
  /// **'Carry Forward Limit'**
  String get carryForwardLimit;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevel;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} days left'**
  String daysLeft(int count);

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @managerActionRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Manager Action Recommendations'**
  String get managerActionRecommendations;

  /// No description provided for @encourageLeavePlanning.
  ///
  /// In en, this message translates to:
  /// **'Encourage Leave Planning'**
  String get encourageLeavePlanning;

  /// No description provided for @encourageLeavePlanningDescription.
  ///
  /// In en, this message translates to:
  /// **'Proactively discuss leave plans with team members who have high at-risk balances'**
  String get encourageLeavePlanningDescription;

  /// No description provided for @approvePendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Approve Pending Requests'**
  String get approvePendingRequests;

  /// No description provided for @approvePendingRequestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Review and approve pending leave requests to help employees utilize their balance'**
  String get approvePendingRequestsDescription;

  /// No description provided for @encashmentOption.
  ///
  /// In en, this message translates to:
  /// **'Encashment Option'**
  String get encashmentOption;

  /// No description provided for @encashmentOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Consider approving encashment requests for employees who cannot take leave'**
  String get encashmentOptionDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
