import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/navigation/sidebar_provider.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar> {
  final Map<String, bool> _expandedItems = {};
  String? _lastAutoExpandedRoute;

  Widget _buildIcon({
    required SidebarItem item,
    required double size,
    required Color color,
  }) {
    if (item.svgPath != null) {
      return SvgIconWidget(
        assetPath: item.svgPath!,
        size: size,
        color: color,
      );
    } else if (item.icon != null) {
      return Icon(
        item.icon,
        size: size,
        color: color,
      );
    }
    return const SizedBox.shrink();
  }

  void _toggleExpanded(String id, List<SidebarItem> allItems) {
    setState(() {
      final isCurrentlyExpanded = _expandedItems[id] ?? false;
      
      // If opening this item, close all other parent items
      if (!isCurrentlyExpanded) {
        // Close all other parent items
        for (final item in allItems) {
          if (item.id != id && item.children != null && item.children!.isNotEmpty) {
            _expandedItems[item.id] = false;
          }
        }
      }
      
      // Toggle the clicked item
      _expandedItems[id] = !isCurrentlyExpanded;
    });
  }

  double _getChildItemFontSize(String key) {
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

  String _getLocalizedLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'appTitle':
        return localizations.appTitle;
      case 'hrManagement':
        return 'HR Management'; // TODO: Add to localization
      case 'dashboard':
        return localizations.dashboard;
      case 'overview':
        return 'Overview'; // TODO: Add to localization
      case 'analytics':
        return 'Analytics'; // TODO: Add to localization
      case 'quickActions':
        return localizations.quickActions;
      case 'moduleCatalogue':
        return localizations.moduleCatalogue;
      case 'productIntro':
        return localizations.productIntroduction;
      case 'enterpriseStructure':
        return localizations.enterpriseStructure;
      case 'manageEnterpriseStructure':
        return 'Manage Enterprise\nStructure'; // TODO: Add to localization
      case 'manageComponentValues':
        return localizations.manageComponentValues;
      case 'company':
        return 'Company'; // TODO: Add to localization
      case 'division':
        return 'Division'; // TODO: Add to localization
      case 'businessUnit':
        return 'Business Unit'; // TODO: Add to localization
      case 'department':
        return 'Department'; // TODO: Add to localization
      case 'section':
        return 'Section'; // TODO: Add to localization
      case 'workforceStructure':
        return localizations.workforceStructure;
      case 'timeManagement':
        return localizations.timeManagement;
      case 'employees':
        return localizations.employees;
      case 'employeeList':
        return 'Employee List'; // TODO: Add to localization
      case 'addEmployee':
        return 'Add Employee'; // TODO: Add to localization
      case 'employeeActions':
        return 'Employee Actions'; // TODO: Add to localization
      case 'orgStructure':
        return 'Org Structure'; // TODO: Add to localization
      case 'workforcePlanning':
        return 'Workforce Planning'; // TODO: Add to localization
      case 'positions':
        return 'Positions'; // TODO: Add to localization
      case 'contracts':
        return 'Contracts'; // TODO: Add to localization
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
        return '${localizations.settings} &\nConfigurations'; // TODO: Add full string to localization
      case 'kuwaitLaborLaw':
        return 'Kuwait Labor Law'; // TODO: Add to localization
      case 'fullyCompliant':
        return 'Fully Compliant System'; // TODO: Add to localization
      default:
        return key;
    }
  }

  List<SidebarItem> _getMenuItems() {
    return [
      SidebarItem(
        id: 'dashboard',
        svgPath: 'assets/icons/dashboard_icon.svg',
        labelKey: 'dashboard',
        children: [
          SidebarItem(
            id: 'overview',
            svgPath: 'assets/icons/overview_icon.svg',
            labelKey: 'overview',
            route: '/dashboard/overview',
          ),
          SidebarItem(
            id: 'analytics',
            svgPath: 'assets/icons/analytics_icon.svg',
            labelKey: 'analytics',
            route: '/dashboard/analytics',
          ),
          SidebarItem(
            id: 'quickActions',
            svgPath: 'assets/icons/quick_actions_icon.svg',
            labelKey: 'quickActions',
            route: '/dashboard/quick-actions',
          ),
        ],
      ),
      SidebarItem(
        id: 'moduleCatalogue',
        svgPath: 'assets/icons/module_catalogue_icon.svg',
        labelKey: 'moduleCatalogue',
        route: '/module-catalogue',
      ),
      SidebarItem(
        id: 'productIntro',
        svgPath: 'assets/icons/product_intro_icon.svg',
        labelKey: 'productIntro',
        route: '/product-intro',
      ),
      SidebarItem(
        id: 'enterpriseStructure',
        svgPath: 'assets/icons/enterprise_structure_icon.svg',
        labelKey: 'enterpriseStructure',
        children: [
          SidebarItem(
            id: 'manageEnterpriseStructure',
            svgPath: 'assets/icons/manage_enterprise_icon.svg',
            labelKey: 'manageEnterpriseStructure',
            route: '/enterprise-structure/manage',
          ),
          SidebarItem(
            id: 'manageComponentValues',
            svgPath: 'assets/icons/manage_component_icon.svg',
            labelKey: 'manageComponentValues',
            route: '/enterprise-structure/component-values',
          ),
          SidebarItem(
            id: 'company',
            svgPath: 'assets/icons/company_icon.svg',
            labelKey: 'company',
            route: '/enterprise-structure/company',
          ),
          SidebarItem(
            id: 'division',
            svgPath: 'assets/icons/division_icon.svg',
            labelKey: 'division',
            route: '/enterprise-structure/division',
          ),
          SidebarItem(
            id: 'businessUnit',
            svgPath: 'assets/icons/business_unit_icon.svg',
            labelKey: 'businessUnit',
            route: '/enterprise-structure/business-unit',
          ),
          SidebarItem(
            id: 'department',
            svgPath: 'assets/icons/department_icon.svg',
            labelKey: 'department',
            route: '/enterprise-structure/department',
          ),
          SidebarItem(
            id: 'section',
            svgPath: 'assets/icons/section_icon.svg',
            labelKey: 'section',
            route: '/enterprise-structure/section',
          ),
        ],
      ),
      SidebarItem(
        id: 'workforceStructure',
        svgPath: 'assets/icons/workforce_structure_icon.svg',
        labelKey: 'workforceStructure',
        route: '/workforce-structure',
      ),
      SidebarItem(
        id: 'timeManagement',
        svgPath: 'assets/icons/time_management_icon.svg',
        labelKey: 'timeManagement',
        route: '/time-management',
      ),
      SidebarItem(
        id: 'employees',
        svgPath: 'assets/icons/employees_icon.svg',
        labelKey: 'employees',
        children: [
          SidebarItem(
            id: 'employeeList',
            svgPath: 'assets/icons/employee_list_icon.svg',
            labelKey: 'employeeList',
            route: '/employees/list',
          ),
          SidebarItem(
            id: 'addEmployee',
            svgPath: 'assets/icons/add_employee_icon.svg',
            labelKey: 'addEmployee',
            route: '/employees/add',
          ),
          SidebarItem(
            id: 'employeeActions',
            svgPath: 'assets/icons/employee_actions_icon.svg',
            labelKey: 'employeeActions',
            route: '/employees/actions',
          ),
          SidebarItem(
            id: 'orgStructure',
            svgPath: 'assets/icons/company_icon.svg',
            labelKey: 'orgStructure',
            route: '/employees/org-structure',
          ),
          SidebarItem(
            id: 'workforcePlanning',
            svgPath: 'assets/icons/workforce_planning_icon.svg',
            labelKey: 'workforcePlanning',
            route: '/employees/workforce-planning',
          ),
          SidebarItem(
            id: 'positions',
            svgPath: 'assets/icons/positions_icon.svg',
            labelKey: 'positions',
            route: '/employees/positions',
          ),
          SidebarItem(
            id: 'contracts',
            svgPath: 'assets/icons/contracts_icon.svg',
            labelKey: 'contracts',
            route: '/employees/contracts',
          ),
        ],
      ),
      SidebarItem(
        id: 'leaveManagement',
        svgPath: 'assets/icons/leave_management_icon.svg',
        labelKey: 'leaveManagement',
        route: '/leave-management',
      ),
      SidebarItem(
        id: 'attendance',
        svgPath: 'assets/icons/attendance_icon.svg',
        labelKey: 'attendance',
        route: '/attendance',
      ),
      SidebarItem(
        id: 'payroll',
        svgPath: 'assets/icons/payroll_icon.svg',
        labelKey: 'payroll',
        route: '/payroll',
      ),
      SidebarItem(
        id: 'compliance',
        svgPath: 'assets/icons/compliance_icon.svg',
        labelKey: 'compliance',
        route: '/compliance',
      ),
      SidebarItem(
        id: 'eosCalculator',
        svgPath: 'assets/icons/eos_calculator_icon.svg',
        labelKey: 'eosCalculator',
        route: '/eos-calculator',
      ),
      SidebarItem(
        id: 'reports',
        svgPath: 'assets/icons/reports_icon.svg',
        labelKey: 'reports',
        route: '/reports',
      ),
      SidebarItem(
        id: 'governmentForms',
        svgPath: 'assets/icons/government_forms_icon.svg',
        labelKey: 'governmentForms',
        route: '/government-forms',
      ),
      SidebarItem(
        id: 'deiDashboard',
        svgPath: 'assets/icons/dei_dashboard_icon.svg',
        labelKey: 'deiDashboard',
        route: '/dei-dashboard',
      ),
      SidebarItem(
        id: 'hrOperations',
        svgPath: 'assets/icons/hr_operations_icon.svg',
        labelKey: 'hrOperations',
        route: '/hr-operations',
      ),
      SidebarItem(
        id: 'settingsConfig',
        svgPath: 'assets/icons/settings_icon.svg',
        labelKey: 'settingsConfig',
        route: '/settings',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(sidebarProvider);
    final localizations = AppLocalizations.of(context)!;
    final menuItems = _getMenuItems();
    final currentRoute = GoRouterState.of(context).uri.path;
    
    // Auto-expand parent items if they have active children (accordion behavior)
    // Only update if route changed to avoid unnecessary rebuilds
    if (_lastAutoExpandedRoute != currentRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        
        String? itemToExpand;
        for (final item in menuItems) {
          if (item.children != null) {
            final hasActiveChild = item.children!.any(
              (child) => child.route == currentRoute,
            );
            if (hasActiveChild) {
              itemToExpand = item.id;
              break; // Only expand the first matching item
            }
          }
        }
        
        // Update expanded items for accordion behavior
        setState(() {
          if (itemToExpand != null) {
            for (final item in menuItems) {
              if (item.children != null && item.children!.isNotEmpty) {
                _expandedItems[item.id] = item.id == itemToExpand;
              }
            }
          }
          _lastAutoExpandedRoute = currentRoute;
        });
      });
    }

    return Material(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isExpanded ? 288.w : 64.w,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context, isExpanded, localizations),
            Expanded(
              child: _buildMenu(context, menuItems, isExpanded, localizations),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1.0,
                    child: child,
                  ),
                );
              },
              child: isExpanded
                  ? _buildFooter(context, localizations)
                  : const SizedBox.shrink(key: ValueKey('footer-hidden')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isExpanded,
    AppLocalizations localizations,
  ) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        top: 16.h,
        bottom: 17.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: isExpanded
            ? Row(
                key: const ValueKey('header-expanded'),
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => ref.read(sidebarProvider.notifier).collapse(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: const Color(0xFF101828),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    List<SidebarItem> items,
    bool isExpanded,
    AppLocalizations localizations,
  ) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: isExpanded ? 16.w : 0,
          vertical: 16.h,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            key: ValueKey('menu-item-${item.id}'),
            padding: EdgeInsetsDirectional.only(
              bottom: index < items.length - 1 ? 4.h : 0,
            ),
            child: _buildMenuItem(
              context,
              item,
              isExpanded,
              localizations,
              items,
            ),
          );
        }).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    SidebarItem item,
    bool isExpanded,
    AppLocalizations localizations,
    List<SidebarItem> allItems,
  ) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpandedItem = _expandedItems[item.id] ?? false;
    final currentRoute = GoRouterState.of(context).uri.path;
    final isActive = item.route == currentRoute ||
        (hasChildren &&
            item.children!.any((child) => child.route == currentRoute));

    if (!isExpanded) {
      return Padding(
        padding: EdgeInsetsDirectional.only(bottom: 4.h),
        child: GestureDetector(
          onTap: () {
            // Always expand sidebar first when collapsed
            ref.read(sidebarProvider.notifier).expand();
            
            // Capture route and hasChildren before async operation
            final route = item.route;
            final hasChildrenLocal = hasChildren;
            
            // Then navigate or expand children after a short delay
            Future.delayed(const Duration(milliseconds: 100), () {
              if (!mounted) return;
              if (route != null && context.mounted) {
                context.go(route);
              } else if (hasChildrenLocal) {
                _toggleExpanded(item.id, allItems);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
              border: isActive
                  ? BorderDirectional(
                      start: BorderSide(
                        color: const Color(0xFF155DFC),
                        width: 2,
                      ),
                    )
                  : null,
            ),
            child: _buildIcon(
              item: item,
              size: 20.sp,
              color: isActive
                  ? const Color(0xFF155DFC)
                  : const Color(0xFF364153),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (hasChildren) {
              _toggleExpanded(item.id, allItems);
            } else if (item.route != null) {
              context.go(item.route!);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
            ),
            child: Row(
              children: [
                _buildIcon(
                  item: item,
                  size: 20.sp,
                  color: isActive
                      ? AppColors.primary
                      : const Color(0xFF364153),
                ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AnimatedOpacity(
                      opacity: isExpanded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _getLocalizedLabel(item.labelKey, localizations),
                        style: TextStyle(
                          fontSize: 15.4.sp,
                          fontWeight: FontWeight.w400,
                          color: isActive
                              ? AppColors.primary
                              : const Color(0xFF364153),
                          height: 24 / 15.4,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                if (hasChildren)
                  AnimatedOpacity(
                    opacity: isExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isExpandedItem
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 16.sp,
                      color: context.themeTextSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasChildren)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpandedItem
                ? Padding(
                    padding: EdgeInsetsDirectional.only(start: 32.w, top: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.children!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final child = entry.value;
                        final currentRoute = GoRouterState.of(context).uri.path;
                        final isChildActive = child.route == currentRoute;
                        final labelText = _getLocalizedLabel(child.labelKey, localizations);
                        final fontSize = _getChildItemFontSize(child.labelKey);
                        final isMultiLine = labelText.contains('\n');
                        final childHeight = isMultiLine ? 64.h : 40.h;
                        
                        return TweenAnimationBuilder<double>(
                          key: ValueKey('child-item-${child.id}'),
                          tween: Tween(begin: 0.0, end: isExpandedItem ? 1.0 : 0.0),
                          duration: Duration(milliseconds: 200 + (index * 20)),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, -20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              bottom: index < item.children!.length - 1 ? 4.h : 0,
                            ),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (child.route != null && mounted) {
                                  context.go(child.route!);
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                height: childHeight,
                                padding: EdgeInsetsDirectional.only(
                                  start: isChildActive ? 14.w : 12.w,
                                  end: 12.w,
                                  top: 8.h,
                                  bottom: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: isChildActive ? const Color(0xFFEFF6FF) : Colors.transparent,
                                  border: isChildActive
                                      ? BorderDirectional(
                                          start: BorderSide(
                                            color: const Color(0xFF155DFC),
                                            width: 2,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                        top: isMultiLine ? 8.h : 0,
                                      ),
                                      child: _buildIcon(
                                        item: child,
                                        size: 16.sp,
                                        color: isChildActive
                                            ? AppColors.primary
                                            : const Color(0xFF4A5565),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.only(
                                          top: isMultiLine ? 0 : 0,
                                        ),
                                        child: Text(
                                          labelText,
                                          style: TextStyle(
                                            fontSize: fontSize.sp,
                                            fontWeight: FontWeight.w400,
                                            color: isChildActive
                                                ? AppColors.primary
                                                : const Color(0xFF4A5565),
                                            height: 24 / fontSize,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Container(
      key: const ValueKey('footer'),
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        top: 17.h,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsetsDirectional.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.sidebarFooterBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getLocalizedLabel('kuwaitLaborLaw', localizations),
              style: TextStyle(
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1C398E),
                height: 24 / 15.1,
                letterSpacing: 0,
              ),
            ),
            Text(
              _getLocalizedLabel('fullyCompliant', localizations),
              style: TextStyle(
                fontSize: 15.3.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1447E6),
                height: 24 / 15.3,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

