import 'package:digify_hr_system/core/navigation/app_layout.dart';
import 'package:digify_hr_system/core/widgets/placeholder_screen.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:digify_hr_system/features/auth/presentation/screens/login_screen.dart';
import 'package:digify_hr_system/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'overview',
                name: 'dashboard-overview',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Dashboard Overview',
                ),
              ),
              GoRoute(
                path: 'analytics',
                name: 'dashboard-analytics',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Analytics',
                ),
              ),
              GoRoute(
                path: 'quick-actions',
                name: 'dashboard-quick-actions',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Quick Actions',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/module-catalogue',
            name: 'module-catalogue',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Module Catalogue',
            ),
          ),
          GoRoute(
            path: '/product-intro',
            name: 'product-intro',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Product Introduction',
            ),
          ),
          GoRoute(
            path: '/enterprise-structure',
            name: 'enterprise-structure',
            redirect: (context, state) => '/enterprise-structure/manage',
            routes: [
              GoRoute(
                path: 'manage',
                name: 'enterprise-structure-manage',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Manage Enterprise Structure',
                ),
              ),
              GoRoute(
                path: 'component-values',
                name: 'enterprise-structure-component-values',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Manage Component Values',
                ),
              ),
              GoRoute(
                path: 'company',
                name: 'enterprise-structure-company',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Company',
                ),
              ),
              GoRoute(
                path: 'division',
                name: 'enterprise-structure-division',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Division',
                ),
              ),
              GoRoute(
                path: 'business-unit',
                name: 'enterprise-structure-business-unit',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Business Unit',
                ),
              ),
              GoRoute(
                path: 'department',
                name: 'enterprise-structure-department',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Department',
                ),
              ),
              GoRoute(
                path: 'section',
                name: 'enterprise-structure-section',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Section',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/workforce-structure',
            name: 'workforce-structure',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Workforce Structure',
            ),
          ),
          GoRoute(
            path: '/time-management',
            name: 'time-management',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Time Management',
            ),
          ),
          GoRoute(
            path: '/employees',
            name: 'employees',
            redirect: (context, state) => '/employees/list',
            routes: [
              GoRoute(
                path: 'list',
                name: 'employees-list',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Employee List',
                ),
              ),
              GoRoute(
                path: 'add',
                name: 'employees-add',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Add Employee',
                ),
              ),
              GoRoute(
                path: 'actions',
                name: 'employees-actions',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Employee Actions',
                ),
              ),
              GoRoute(
                path: 'org-structure',
                name: 'employees-org-structure',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Org Structure',
                ),
              ),
              GoRoute(
                path: 'workforce-planning',
                name: 'employees-workforce-planning',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Workforce Planning',
                ),
              ),
              GoRoute(
                path: 'positions',
                name: 'employees-positions',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Positions',
                ),
              ),
              GoRoute(
                path: 'contracts',
                name: 'employees-contracts',
                builder: (context, state) => const PlaceholderScreen(
                  title: 'Contracts',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/leave-management',
            name: 'leave-management',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Leave Management',
            ),
          ),
          GoRoute(
            path: '/attendance',
            name: 'attendance',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Attendance',
            ),
          ),
          GoRoute(
            path: '/payroll',
            name: 'payroll',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Payroll',
            ),
          ),
          GoRoute(
            path: '/compliance',
            name: 'compliance',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Compliance',
            ),
          ),
          GoRoute(
            path: '/eos-calculator',
            name: 'eos-calculator',
            builder: (context, state) => const PlaceholderScreen(
              title: 'EOS Calculator',
            ),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Reports',
            ),
          ),
          GoRoute(
            path: '/government-forms',
            name: 'government-forms',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Government Forms',
            ),
          ),
          GoRoute(
            path: '/dei-dashboard',
            name: 'dei-dashboard',
            builder: (context, state) => const PlaceholderScreen(
              title: 'DEI Dashboard',
            ),
          ),
          GoRoute(
            path: '/hr-operations',
            name: 'hr-operations',
            builder: (context, state) => const PlaceholderScreen(
              title: 'HR Operations',
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Settings & Configurations',
            ),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            redirect: (context, state) => '/dashboard',
          ),
        ],
      ),
    ],
  );
});


