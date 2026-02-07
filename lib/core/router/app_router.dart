import 'package:digify_hr_system/core/navigation/app_layout.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:digify_hr_system/core/widgets/feedback/placeholder_screen.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:digify_hr_system/features/auth/presentation/screens/login_screen.dart';
import 'package:digify_hr_system/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/business_unit_management_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/company_management_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/division_management_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/department_management_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/section_management_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_component_values_screen.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/screens/manage_enterprise_structure_screen.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/screens/workforce_structure_screen.dart';
import 'package:digify_hr_system/features/time_management/presentation/screens/time_management_screen.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/presentation/screens/employee_management_screens.dart';
import 'package:digify_hr_system/features/leave_management/presentation/screens/leave_management_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.signup;

      if (!isAuthenticated && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isLoggingIn) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, name: 'login', builder: (context, state) => const LoginScreen()),
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
                path: 'overview',
                name: 'dashboard-overview',
                builder: (context, state) => const PlaceholderScreen(title: 'Dashboard Overview'),
              ),
              GoRoute(
                path: 'analytics',
                name: 'dashboard-analytics',
                builder: (context, state) => const PlaceholderScreen(title: 'Analytics'),
              ),
              GoRoute(
                path: 'quick-actions',
                name: 'dashboard-quick-actions',
                builder: (context, state) => const PlaceholderScreen(title: 'Quick Actions'),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.moduleCatalogue,
            name: 'module-catalogue',
            builder: (context, state) => const PlaceholderScreen(title: 'Module Catalogue'),
          ),
          GoRoute(
            path: AppRoutes.productIntro,
            name: 'product-intro',
            builder: (context, state) => const PlaceholderScreen(title: 'Product Introduction'),
          ),
          GoRoute(
            path: AppRoutes.enterpriseStructure,
            name: 'enterprise-structure',
            redirect: (context, state) {
              if (state.uri.path == AppRoutes.enterpriseStructure) {
                return AppRoutes.enterpriseStructureManage;
              }
              return null; // No redirect needed
            },
            routes: [
              GoRoute(
                path: 'manage',
                name: 'enterprise-structure-manage',
                builder: (context, state) => const ManageEnterpriseStructureScreen(),
              ),
              GoRoute(
                path: 'component-values',
                name: 'enterprise-structure-component-values',
                builder: (context, state) => const ManageComponentValuesScreen(),
              ),
              GoRoute(
                path: 'company',
                name: 'enterprise-structure-company',
                builder: (context, state) => const CompanyManagementScreen(),
              ),
              GoRoute(
                path: 'division',
                name: 'enterprise-structure-division',
                builder: (context, state) => const DivisionManagementScreen(),
              ),
              GoRoute(
                path: 'business-unit',
                name: 'enterprise-structure-business-unit',
                builder: (context, state) => const BusinessUnitManagementScreen(),
              ),
              GoRoute(
                path: 'department',
                name: 'enterprise-structure-department',
                builder: (context, state) => const DepartmentManagementScreen(),
              ),
              GoRoute(
                path: 'section',
                name: 'enterprise-structure-section',
                builder: (context, state) => const SectionManagementScreen(),
              ),
            ],
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
                  final employee = state.extra is EmployeeListItem ? state.extra! as EmployeeListItem : null;
                  if (employee == null) {
                    return Scaffold(body: Center(child: Text('Employee not found')));
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
          ),
          GoRoute(
            path: AppRoutes.attendance,
            name: 'attendance',
            builder: (context, state) => const PlaceholderScreen(title: 'Attendance'),
          ),
          GoRoute(
            path: AppRoutes.payroll,
            name: 'payroll',
            builder: (context, state) => const PlaceholderScreen(title: 'Payroll'),
          ),
          GoRoute(
            path: AppRoutes.compliance,
            name: 'compliance',
            builder: (context, state) => const PlaceholderScreen(title: 'Compliance'),
          ),
          GoRoute(
            path: AppRoutes.eosCalculator,
            name: 'eos-calculator',
            builder: (context, state) => const PlaceholderScreen(title: 'EOS Calculator'),
          ),
          GoRoute(
            path: AppRoutes.reports,
            name: 'reports',
            builder: (context, state) => const PlaceholderScreen(title: 'Reports'),
          ),
          GoRoute(
            path: AppRoutes.governmentForms,
            name: 'government-forms',
            builder: (context, state) => const PlaceholderScreen(title: 'Government Forms'),
          ),
          GoRoute(
            path: AppRoutes.deiDashboard,
            name: 'dei-dashboard',
            builder: (context, state) => const PlaceholderScreen(title: 'DEI Dashboard'),
          ),
          GoRoute(
            path: AppRoutes.hrOperations,
            name: 'hr-operations',
            builder: (context, state) => const PlaceholderScreen(title: 'HR Operations'),
          ),
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const PlaceholderScreen(title: 'Settings & Configurations'),
          ),
          GoRoute(path: AppRoutes.home, name: 'home', redirect: (context, state) => AppRoutes.dashboard),
        ],
      ),
    ],
  );
});
