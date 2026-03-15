import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user_management/functional_privileges.dart';
import '../../../data/models/user_management/user_role.dart';

class UserFormState {
  // Account Information
  final String? userId;
  final String? userName;
  final String? accountStatus;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? confirmPassword;
  final DateTime? passwordExpiration;
  final bool? neverExpire;
  final DateTime? accountExpiration;

  // Contact Information
  final String? email;
  final String? secondaryEmail;
  final String? workPhone;
  final String? mobilePhone;
  final String? extension;
  final String? officeLocation;
  final String? mailingAddress;

  // Employment Information
  final String? department;
  final String? jobTitle;
  final String? employeeType;
  final String? reportToManager;
  final String? workLocation;
  final DateTime? hireDate;
  final DateTime? startDate;
  final DateTime? endDate;

  // Roles & Responsibilities
  final List<int> assignedRoles;
  final List<UserRole> availableRoles;

  // Access & Permissions
  final List<FunctionalPrivileges> availableFunctionalPrivileges;
  final List<FunctionalPrivileges> filteredFunctionalPrivileges;
  final List<int> selectedFunctionalPrivileges;

  // User Preferences
  final String? language;
  final String? timeZone;
  final String? dateFormat;
  final String? currency;
  final bool? receiveEmailNotifications;
  final bool? receiveSmsNotifications;
  final bool? receivePushNotifications;
  final bool? allowWorkflowAlerts;
  final String? itemsPerPage;
  final bool? compactView;
  final bool? showTooltips;

  // Security Settings
  final bool? enable2FA;
  final bool? forcePasswordChange;
  final bool? accountLockout;
  final int? failedLoginAttempts;
  final int? sessionTimeOut;
  final bool? allowConcurrentSession;
  final bool? ipAddressRestriction;
  final bool? auditUserActions;
  final bool? dataAccessLogging;
  final bool? complianceAlert;

  UserFormState({
    this.userId,
    this.userName,
    this.accountStatus,
    this.firstName,
    this.lastName,
    this.password,
    this.confirmPassword,
    this.passwordExpiration,
    this.neverExpire,
    this.accountExpiration,
    this.email,
    this.secondaryEmail,
    this.workPhone,
    this.mobilePhone,
    this.extension,
    this.officeLocation,
    this.mailingAddress,
    this.department,
    this.jobTitle,
    this.employeeType,
    this.reportToManager,
    this.workLocation,
    this.hireDate,
    this.startDate,
    this.endDate,
    this.assignedRoles = const [],
    this.availableRoles = const [],
    this.availableFunctionalPrivileges = const [],
    this.filteredFunctionalPrivileges = const [],
    this.selectedFunctionalPrivileges = const [],
    this.language,
    this.timeZone,
    this.dateFormat,
    this.currency,
    this.receiveEmailNotifications,
    this.receiveSmsNotifications,
    this.receivePushNotifications,
    this.allowWorkflowAlerts,
    this.itemsPerPage,
    this.compactView,
    this.showTooltips,
    this.enable2FA,
    this.forcePasswordChange,
    this.accountLockout,
    this.failedLoginAttempts,
    this.sessionTimeOut,
    this.allowConcurrentSession,
    this.ipAddressRestriction,
    this.auditUserActions,
    this.dataAccessLogging,
    this.complianceAlert,
  });

  UserFormState copyWith({
    String? userId,
    String? userName,
    String? accountStatus,
    String? firstName,
    String? lastName,
    String? password,
    String? confirmPassword,
    DateTime? passwordExpiration,
    bool? neverExpire,
    DateTime? accountExpiration,
    String? email,
    String? secondaryEmail,
    String? workPhone,
    String? mobilePhone,
    String? extension,
    String? officeLocation,
    String? mailingAddress,
    String? department,
    String? jobTitle,
    String? employeeType,
    String? reportToManager,
    String? workLocation,
    DateTime? hireDate,
    DateTime? startDate,
    DateTime? endDate,
    List<int>? assignedRoles,
    List<UserRole>? availableRoles,
    List<FunctionalPrivileges>? availableFunctionalPrivileges,
    List<FunctionalPrivileges>? filteredFunctionalPrivileges,
    List<int>? selectedFunctionalPrivileges,
    String? language,
    String? timeZone,
    String? dateFormat,
    String? currency,
    bool? receiveEmailNotifications,
    bool? receiveSmsNotifications,
    bool? receivePushNotifications,
    bool? allowWorkflowAlerts,
    String? itemsPerPage,
    bool? compactView,
    bool? showTooltips,
    bool? enable2FA,
    bool? forcePasswordChange,
    bool? accountLockout,
    int? failedLoginAttempts,
    int? sessionTimeOut,
    bool? allowConcurrentSession,
    bool? ipAddressRestriction,
    bool? auditUserActions,
    bool? dataAccessLogging,
    bool? complianceAlert,
  }) {
    return UserFormState(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      accountStatus: accountStatus ?? this.accountStatus,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordExpiration: passwordExpiration ?? this.passwordExpiration,
      neverExpire: neverExpire ?? this.neverExpire,
      accountExpiration: accountExpiration ?? this.accountExpiration,
      email: email ?? this.email,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      workPhone: workPhone ?? this.workPhone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      extension: extension ?? this.extension,
      officeLocation: officeLocation ?? this.officeLocation,
      mailingAddress: mailingAddress ?? this.mailingAddress,
      department: department ?? this.department,
      jobTitle: jobTitle ?? this.jobTitle,
      employeeType: employeeType ?? this.employeeType,
      reportToManager: reportToManager ?? this.reportToManager,
      workLocation: workLocation ?? this.workLocation,
      hireDate: hireDate ?? this.hireDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      assignedRoles: assignedRoles ?? this.assignedRoles,
      availableRoles: availableRoles ?? this.availableRoles,
      availableFunctionalPrivileges:
          availableFunctionalPrivileges ?? this.availableFunctionalPrivileges,
      filteredFunctionalPrivileges:
          filteredFunctionalPrivileges ?? this.filteredFunctionalPrivileges,
      selectedFunctionalPrivileges:
          selectedFunctionalPrivileges ?? this.selectedFunctionalPrivileges,
      language: language ?? this.language,
      timeZone: timeZone ?? this.timeZone,
      dateFormat: dateFormat ?? this.dateFormat,
      currency: currency ?? this.currency,
      receiveEmailNotifications:
          receiveEmailNotifications ?? this.receiveEmailNotifications,
      receiveSmsNotifications:
          receiveSmsNotifications ?? this.receiveSmsNotifications,
      receivePushNotifications:
          receivePushNotifications ?? this.receivePushNotifications,
      allowWorkflowAlerts: allowWorkflowAlerts ?? this.allowWorkflowAlerts,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      compactView: compactView ?? this.compactView,
      showTooltips: showTooltips ?? this.showTooltips,
      enable2FA: enable2FA ?? this.enable2FA,
      forcePasswordChange: forcePasswordChange ?? this.forcePasswordChange,
      accountLockout: accountLockout ?? this.accountLockout,
      failedLoginAttempts: failedLoginAttempts ?? this.failedLoginAttempts,
      sessionTimeOut: sessionTimeOut ?? this.sessionTimeOut,
      allowConcurrentSession:
          allowConcurrentSession ?? this.allowConcurrentSession,
      ipAddressRestriction: ipAddressRestriction ?? this.ipAddressRestriction,
      auditUserActions: auditUserActions ?? this.auditUserActions,
      dataAccessLogging: dataAccessLogging ?? this.dataAccessLogging,
      complianceAlert: complianceAlert ?? this.complianceAlert,
    );
  }
}

class UserFormProvider extends StateNotifier<UserFormState> {
  UserFormProvider() : super(UserFormState()) {
    loadAvailableRoles();
    loadFunctionalPrivileges();
  }

  void loadAvailableRoles() {
    state = state.copyWith(
      availableRoles: [
        UserRole(
          id: 1,
          title: "HR Administrator",
          description: "Full access to HR Module",
          type: "Application Role",
          userCount: 4,
        ),
        UserRole(
          id: 2,
          title: "Payroll Administrator",
          description: "Manage payroll operations",
          type: "Application Role",
          userCount: 2,
        ),
        UserRole(
          id: 3,
          title: "Department Manager",
          description: "Manage department employees",
          type: "Job Role",
          userCount: 8,
        ),
        UserRole(
          id: 4,
          title: "Employee",
          description: "Basic employee access",
          type: "Abstract Role",
          userCount: 150,
        ),
        UserRole(
          id: 5,
          title: "Recruiter",
          description: "Manage recruitment process",
          type: "Function Role",
          userCount: 2,
        ),
        UserRole(
          id: 6,
          title: "Time Administrator",
          description: "Manage time and attendance process",
          type: "Function Role",
          userCount: 4,
        ),
      ],
    );
  }

  void loadFunctionalPrivileges() {
    final privileges = [
      FunctionalPrivileges(
        id: 1,
        name: "View All Employees",
        description: "Access to view all employee records",
        type: "Employee Management",
      ),
      FunctionalPrivileges(
        id: 2,
        name: "Manage Payroll",
        description: "Process and approve payroll",
        type: "Payroll",
      ),
      FunctionalPrivileges(
        id: 3,
        name: "Approve Leave Requests",
        description: "Approve/Reject employee leave ",
        type: "Leave Management",
      ),
      FunctionalPrivileges(
        id: 4,
        name: "Access Reports",
        description: "View and generate reports",
        type: "Reporting",
      ),
      FunctionalPrivileges(
        id: 5,
        name: "Manage Recruitment",
        description: "Post jobs and manage candidates",
        type: "Recruitment",
      ),
      FunctionalPrivileges(
        id: 6,
        name: "System Administration",
        description: "Configure system settings",
        type: "Administration",
      ),
      FunctionalPrivileges(
        id: 7,
        name: "Edit Employee Records",
        description: "Modify employee information",
        type: "Employee Management",
      ),
      FunctionalPrivileges(
        id: 8,
        name: "View Salary Information",
        description: "Access salary and compensation data",
        type: "Payroll",
      ),
      FunctionalPrivileges(
        id: 9,
        name: "Manage Performance Reviews",
        description: "Create and manage performance evaluations",
        type: "Performance",
      ),
      FunctionalPrivileges(
        id: 10,
        name: "Approve Expense Claims",
        description: "Review and approve expenses",
        type: "Finance",
      ),
      FunctionalPrivileges(
        id: 11,
        name: "Manage Training Programs",
        description: "Create and assign training courses",
        type: "Learning & Development",
      ),
      FunctionalPrivileges(
        id: 12,
        name: "Access Audit Logs",
        description: "View system activity logs",
        type: "Security",
      ),
      FunctionalPrivileges(
        id: 13,
        name: "Configure Workflows",
        description: "Design and modify approval workflows",
        type: "Administration",
      ),
      FunctionalPrivileges(
        id: 14,
        name: "Manage Benefits",
        description: "Administer employee benefits",
        type: "Benefits",
      ),
      FunctionalPrivileges(
        id: 15,
        name: "Time & Attendance Admin",
        description: "Manage attendance and schedules",
        type: "Time Management",
      ),
      FunctionalPrivileges(
        id: 16,
        name: "Create Announcements",
        description: "Post company-wide announcements",
        type: "Communication",
      ),
      FunctionalPrivileges(
        id: 17,
        name: "Manage Positions",
        description: "Create and modify job positions",
        type: "Organization Structure",
      ),
      FunctionalPrivileges(
        id: 18,
        name: "Approve Overtime",
        description: "Review and approve overtime requests",
        type: "Time Management",
      ),
    ];
    state = state.copyWith(
      availableFunctionalPrivileges: privileges,
      filteredFunctionalPrivileges: privileges,
    );
  }

  void setUserId(String userId) {
    state = state.copyWith(userId: userId);
  }

  void setUserName(String userName) {
    state = state.copyWith(userName: userName);
  }

  void setAccountStatus(String accountStatus) {
    state = state.copyWith(accountStatus: accountStatus);
  }

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void setPasswordExpiration(DateTime passwordExpiration) {
    state = state.copyWith(passwordExpiration: passwordExpiration);
  }

  void setNeverExpire(bool neverExpire) {
    state = state.copyWith(neverExpire: neverExpire);
  }

  void setAccountExpiration(DateTime accountExpiration) {
    state = state.copyWith(accountExpiration: accountExpiration);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setSecondaryEmail(String secondaryEmail) {
    state = state.copyWith(secondaryEmail: secondaryEmail);
  }

  void setWorkPhone(String workPhone) {
    state = state.copyWith(workPhone: workPhone);
  }

  void setMobilePhone(String mobilePhone) {
    state = state.copyWith(mobilePhone: mobilePhone);
  }

  void setExtension(String extension) {
    state = state.copyWith(extension: extension);
  }

  void setOfficeLocation(String officeLocation) {
    state = state.copyWith(officeLocation: officeLocation);
  }

  void setMailingAddress(String mailingAddress) {
    state = state.copyWith(mailingAddress: mailingAddress);
  }

  void setDepartment(String department) {
    state = state.copyWith(department: department);
  }

  void setJobTitle(String jobTitle) {
    state = state.copyWith(jobTitle: jobTitle);
  }

  void setEmployeeType(String employeeType) {
    state = state.copyWith(employeeType: employeeType);
  }

  void setReportToManager(String reportToManager) {
    state = state.copyWith(reportToManager: reportToManager);
  }

  void setWorkLocation(String workLocation) {
    state = state.copyWith(workLocation: workLocation);
  }

  void setHireDate(DateTime hireDate) {
    state = state.copyWith(hireDate: hireDate);
  }

  void setStartDate(DateTime startDate) {
    state = state.copyWith(startDate: startDate);
  }

  void setEndDate(DateTime endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void setRole(int id) {
    List<int> roles = List<int>.from(state.assignedRoles);
    if (roles.contains(id)) {
      roles.remove(id);
    } else {
      roles.add(id);
    }
    state = state.copyWith(assignedRoles: roles);
  }

  void setAvailableRoles(List<UserRole> availableRoles) {
    state = state.copyWith(availableRoles: availableRoles);
  }

  void setFunctionalPrivilege(int id) {
    List<int> functionalPrivileges = List<int>.from(
      state.selectedFunctionalPrivileges,
    );
    if (functionalPrivileges.contains(id)) {
      functionalPrivileges.remove(id);
    } else {
      functionalPrivileges.add(id);
    }
    state = state.copyWith(selectedFunctionalPrivileges: functionalPrivileges);
  }

  void searchFunctionalPrivileges(String query) {
    final filteredPrivileges = state.availableFunctionalPrivileges.where((
      privilege,
    ) {
      return privilege.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredFunctionalPrivileges: filteredPrivileges);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void setTimeZone(String timeZone) {
    state = state.copyWith(timeZone: timeZone);
  }

  void setDateFormat(String dateFormat) {
    state = state.copyWith(dateFormat: dateFormat);
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void setReceiveEmailNotifications(bool receiveEmailNotifications) {
    state = state.copyWith(
      receiveEmailNotifications: receiveEmailNotifications,
    );
  }

  void setReceiveSmsNotifications(bool receiveSmsNotifications) {
    state = state.copyWith(receiveSmsNotifications: receiveSmsNotifications);
  }

  void setReceivePushNotifications(bool receivePushNotifications) {
    state = state.copyWith(receivePushNotifications: receivePushNotifications);
  }

  void setAllowWorkflowAlerts(bool allowWorkflowAlerts) {
    state = state.copyWith(allowWorkflowAlerts: allowWorkflowAlerts);
  }

  void setItemsPerPage(String itemsPerPage) {
    state = state.copyWith(itemsPerPage: itemsPerPage);
  }

  void setCompactView(bool compactView) {
    state = state.copyWith(compactView: compactView);
  }

  void setShowTooltips(bool showTooltips) {
    state = state.copyWith(showTooltips: showTooltips);
  }

  void setEnable2FA(bool enable2FA) {
    state = state.copyWith(enable2FA: enable2FA);
  }

  void setForcePasswordChange(bool forcePasswordChange) {
    state = state.copyWith(forcePasswordChange: forcePasswordChange);
  }

  void setAccountLockout(bool accountLockout) {
    state = state.copyWith(accountLockout: accountLockout);
  }

  void setFailedLoginAttempts(int failedLoginAttempts) {
    state = state.copyWith(failedLoginAttempts: failedLoginAttempts);
  }

  void setSessionTimeOut(int sessionTimeOut) {
    state = state.copyWith(sessionTimeOut: sessionTimeOut);
  }

  void setAllowConcurrentSession(bool allowConcurrentSession) {
    state = state.copyWith(allowConcurrentSession: allowConcurrentSession);
  }

  void setIpAddressRestriction(bool ipAddressRestriction) {
    state = state.copyWith(ipAddressRestriction: ipAddressRestriction);
  }

  void setAuditUserActions(bool auditUserActions) {
    state = state.copyWith(auditUserActions: auditUserActions);
  }

  void setDataAccessLogging(bool dataAccessLogging) {
    state = state.copyWith(dataAccessLogging: dataAccessLogging);
  }

  void setComplianceAlert(bool complianceAlert) {
    state = state.copyWith(complianceAlert: complianceAlert);
  }
}

final userFormProvider = StateNotifierProvider<UserFormProvider, UserFormState>(
  (ref) => UserFormProvider(),
);
