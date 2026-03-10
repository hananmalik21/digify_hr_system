import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/compensation/presentation/screens/compensation_screen.dart';
import '../../features/dashboard/presentation/module_selection/module_selection_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/employee_management/domain/models/employee_list_item.dart';
import '../../features/employee_management/presentation/screens/employee_management_screens.dart';
import '../../features/enterprise_structure/presentation/screens/enterprise_structure_screen.dart';
import '../../features/leave_management/presentation/screens/leave_management_screen.dart';
import '../../features/leave_management/presentation/screens/leave_request_employee_detail_screen.dart';
import '../../features/time_management/presentation/screens/time_management_screen.dart';
import '../../features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import '../../features/time_tracking_and_attendance/presentation/screens/time_tracking_and_attendance_screen.dart';
import '../../features/time_tracking_and_attendance/presentation/screens/timesheet_detail_screen.dart';
import '../../features/security_manager/presentation/screens/security_manager_screen.dart';
import '../../features/workforce_structure/presentation/screens/workforce_structure_screen.dart';
import '../navigation/app_layout.dart';
import '../navigation/root_navigator_key.dart';
import '../widgets/feedback/placeholder_screen.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      if (authState.isRestoring) return null;

      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isLoggingIn) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path:
                    'module-selection/:${AppRoutes.dashboardModuleSelectionParam}',
                name: 'module-selection',
                builder: (context, state) {
                  final moduleId =
                      state.pathParameters[AppRoutes
                          .dashboardModuleSelectionParam] ??
                      '';
                  return ModuleSelectionScreen(moduleId: moduleId);
                },
              ),
              GoRoute(
                path: 'overview',
                name: 'dashboard-overview',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Dashboard Overview'),
              ),
              GoRoute(
                path: 'analytics',
                name: 'dashboard-analytics',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Analytics'),
              ),
              GoRoute(
                path: 'quick-actions',
                name: 'dashboard-quick-actions',
                builder: (context, state) =>
                    const PlaceholderScreen(title: 'Quick Actions'),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.moduleCatalogue,
            name: 'module-catalogue',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Module Catalogue'),
          ),
          GoRoute(
            path: AppRoutes.productIntro,
            name: 'product-intro',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Product Introduction'),
          ),
          GoRoute(
            path: AppRoutes.enterpriseStructure,
            name: 'enterprise-structure',
            builder: (context, state) => const EnterpriseStructureScreen(),
          ),
          GoRoute(
            path: AppRoutes.workforceStructure,
            name: 'workforce-structure',
            builder: (context, state) => const WorkforceStructureScreen(),
          ),
          GoRoute(
            path: AppRoutes.timeManagement,
            name: 'time-management',
            builder: (context, state) => const TimeManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.employees,
            name: 'employees',
            builder: (context, state) => const EmployeeManagementScreen(),
            routes: [
              GoRoute(
                path: 'detail',
                name: 'employee-detail',
                builder: (context, state) {
                  final employee = state.extra is EmployeeListItem
                      ? state.extra! as EmployeeListItem
                      : null;
                  if (employee == null) {
                    return Scaffold(
                      body: Center(child: Text('Employee not found')),
                    );
                  }
                  return EmployeeDetailScreen(employee: employee);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.leaveManagement,
            name: 'leave-management',
            builder: (context, state) => const LeaveManagementScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.leaveManagementEmployeeLeaveHistorySegment,
                name: 'leave-management-employee-leave-history',
                builder: (context, state) {
                  final employeeGuid = state.extra is String
                      ? state.extra! as String
                      : null;
                  if (employeeGuid == null || employeeGuid.isEmpty) {
                    return Scaffold(
                      body: Center(child: Text('Invalid navigation state')),
                    );
                  }
                  return LeaveRequestEmployeeDetailScreen(
                    employeeGuid: employeeGuid,
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.timeTrackingAndAttendance,
            name: 'time-tracking-and-attendance',
            builder: (context, state) =>
                const TimeTrackingAndAttendanceScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.timeTrackingTimesheetDetailSegment,
                name: 'time-tracking-timesheet-detail',
                builder: (context, state) {
                  final timesheet = state.extra is Timesheet
                      ? state.extra! as Timesheet
                      : null;
                  if (timesheet == null) {
                    return const Scaffold(
                      body: Center(child: Text('Invalid navigation state')),
                    );
                  }
                  return TimesheetDetailScreen(timesheet: timesheet);
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.compensation,
            name: 'compensation',
            builder: (context, state) => const CompensationScreen(),
          ),
          GoRoute(
            path: AppRoutes.securityManager,
            name: 'security-manager',
            builder: (context, state) => const SecurityManagerScreen(),
          ),
          GoRoute(
            path: AppRoutes.payroll,
            name: 'payroll',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Payroll'),
          ),
          GoRoute(
            path: AppRoutes.compliance,
            name: 'compliance',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Compliance'),
          ),
          GoRoute(
            path: AppRoutes.eosCalculator,
            name: 'eos-calculator',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'EOS Calculator'),
          ),
          GoRoute(
            path: AppRoutes.reports,
            name: 'reports',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Reports'),
          ),
          GoRoute(
            path: AppRoutes.governmentForms,
            name: 'government-forms',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Government Forms'),
          ),
          GoRoute(
            path: AppRoutes.deiDashboard,
            name: 'dei-dashboard',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'DEI Dashboard'),
          ),
          GoRoute(
            path: AppRoutes.hrOperations,
            name: 'hr-operations',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'HR Operations'),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) =>
                const PlaceholderScreen(title: 'Settings & Configurations'),
          ),
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            redirect: (context, state) => AppRoutes.dashboard,
          ),
        ],
      ),
    ],
  );
});
