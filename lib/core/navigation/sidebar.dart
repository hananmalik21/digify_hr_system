import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/sidebar_provider.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_tab_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
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

  /// Maps time management sidebar item IDs to their corresponding tab indexes
  int? _getTimeManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'shifts':
        return 0;
      case 'workPatterns':
        return 1;
      case 'workSchedules':
        return 2;
      case 'scheduleAssignments':
        return 3;
      case 'viewCalendar':
        return 4;
      case 'publicHolidays':
        return 5;
      default:
        return null;
    }
  }

  /// Maps workforce structure sidebar item IDs to their corresponding tab indexes
  int? _getWorkforceStructureTabIndex(String itemId) {
    switch (itemId) {
      case 'positions':
        return 0;
      case 'jobFamilies':
        return 1;
      case 'jobLevels':
        return 2;
      case 'gradeStructure':
        return 3;
      case 'reportingStructure':
        return 4;
      case 'positionTree':
        return 5;
      default:
        return null;
    }
  }

  int? _getLeaveManagementTabIndex(String itemId) {
    switch (itemId) {
      case 'leaveRequests':
        return 0;
      case 'leaveBalance':
        return 1;
      case 'myLeaveBalance':
        return 2;
      case 'teamLeaveRisk':
        return 3;
      case 'leavePolicies':
        return 4;
      case 'policyConfiguration':
        return 5;
      case 'forfeitPolicy':
        return 6;
      case 'forfeitProcessing':
        return 7;
      case 'forfeitReports':
        return 8;
      case 'leaveCalendar':
        return 9;
      default:
        return null;
    }
  }

  void _handleNavigation(SidebarItem item) {
    if (item.route != null && mounted) {
      context.go(item.route!);

      if (item.route == AppRoutes.timeManagement) {
        final tabIndex = _getTimeManagementTabIndex(item.id);
        if (tabIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(timeManagementTabStateProvider.notifier).setTabIndex(tabIndex);
            }
          });
        }
      } else if (item.route == AppRoutes.workforceStructure) {
        final tabIndex = _getWorkforceStructureTabIndex(item.id);
        if (tabIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(workforceTabStateProvider.notifier).setTabIndex(tabIndex);
            }
          });
        }
      } else if (item.route == AppRoutes.leaveManagement) {
        final tabIndex = _getLeaveManagementTabIndex(item.id);
        if (tabIndex != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(leaveManagementTabStateProvider.notifier).setTabIndex(tabIndex);
            }
          });
        }
      }
    }
  }

  Widget _buildIcon({required SidebarItem item, required double size, required Color color}) {
    if (item.svgPath != null) {
      return DigifyAsset(assetPath: item.svgPath!, width: size, height: size, color: color);
    } else if (item.icon != null) {
      return Icon(item.icon, size: size, color: color);
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

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(sidebarProvider);
    final localizations = AppLocalizations.of(context)!;
    final menuItems = SidebarConfig.getMenuItems();
    final currentRoute = GoRouterState.of(context).uri.path;

    // Auto-expand parent items if they have active children (accordion behavior)
    // Only update if route changed to avoid unnecessary rebuilds
    if (_lastAutoExpandedRoute != currentRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        String? itemToExpand;
        for (final item in menuItems) {
          if (item.children != null) {
            final hasActiveChild = item.children!.any((child) => child.route == currentRoute);
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context, isExpanded, localizations),
            Expanded(child: _buildMenu(context, menuItems, isExpanded, localizations)),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, axisAlignment: -1.0, child: child),
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

  Widget _buildHeader(BuildContext context, bool isExpanded, AppLocalizations localizations) {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 16.h, bottom: 17.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
                      child: Icon(Icons.close, size: 20.sp, color: const Color(0xFF101828)),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, List<SidebarItem> items, bool isExpanded, AppLocalizations localizations) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: isExpanded ? 16.w : 0, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              key: ValueKey('menu-item-${item.id}'),
              padding: EdgeInsetsDirectional.only(bottom: index < items.length - 1 ? 4.h : 0),
              child: _buildMenuItem(context, item, isExpanded, localizations, items),
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
    final isActive =
        item.route == currentRoute || (hasChildren && item.children!.any((child) => child.route == currentRoute));

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
              border: isActive ? BorderDirectional(start: BorderSide(color: const Color(0xFF155DFC), width: 2)) : null,
            ),
            child: _buildIcon(
              item: item,
              size: 20.sp,
              color: isActive ? const Color(0xFF155DFC) : const Color(0xFF364153),
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
            } else {
              _handleNavigation(item);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildIcon(item: item, size: 20.sp, color: isActive ? AppColors.primary : const Color(0xFF364153)),
                SizedBox(width: 12.w),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: isExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      SidebarConfig.getLocalizedLabel(item.labelKey, localizations),
                      style: TextStyle(
                        fontSize: 15.4.sp,
                        fontWeight: FontWeight.w400,
                        color: isActive ? AppColors.primary : const Color(0xFF364153),
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
                      isExpandedItem ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
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
                        // For time management, workforce structure, and leave management, check both route and tab index
                        final isChildActive =
                            item.id == 'timeManagement' ||
                                item.id == 'workforceStructure' ||
                                item.id == 'leaveManagement'
                            ? (currentRoute == child.route &&
                                  ((item.id == 'timeManagement' &&
                                          _getTimeManagementTabIndex(child.id) ==
                                              ref.watch(
                                                timeManagementTabStateProvider.select((s) => s.currentTabIndex),
                                              )) ||
                                      (item.id == 'workforceStructure' &&
                                          _getWorkforceStructureTabIndex(child.id) ==
                                              ref.watch(workforceTabStateProvider.select((s) => s.currentTabIndex))) ||
                                      (item.id == 'leaveManagement' &&
                                          _getLeaveManagementTabIndex(child.id) ==
                                              ref.watch(
                                                leaveManagementTabStateProvider.select((s) => s.currentTabIndex),
                                              ))))
                            : child.route == currentRoute;
                        final labelText = SidebarConfig.getLocalizedLabel(child.labelKey, localizations);
                        final fontSize = SidebarConfig.getChildItemFontSize(child.labelKey);
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
                              child: Transform.translate(offset: Offset(0, -20 * (1 - value)), child: child),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(bottom: index < item.children!.length - 1 ? 4.h : 0),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (mounted) {
                                  _handleNavigation(child);
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
                                      ? BorderDirectional(start: BorderSide(color: const Color(0xFF155DFC), width: 2))
                                      : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(top: isMultiLine ? 8.h : 0),
                                      child: _buildIcon(
                                        item: child,
                                        size: 16.sp,
                                        color: isChildActive ? AppColors.primary : const Color(0xFF4A5565),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.only(top: isMultiLine ? 0 : 0),
                                        child: Text(
                                          labelText,
                                          style: TextStyle(
                                            fontSize: fontSize.sp,
                                            fontWeight: FontWeight.w400,
                                            color: isChildActive ? AppColors.primary : const Color(0xFF4A5565),
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

  Widget _buildFooter(BuildContext context, AppLocalizations localizations) {
    return Container(
      key: const ValueKey('footer'),
      padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 17.h, bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Container(
        padding: EdgeInsetsDirectional.all(12.w),
        decoration: BoxDecoration(color: AppColors.sidebarFooterBg, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SidebarConfig.getLocalizedLabel('kuwaitLaborLaw', localizations),
              style: TextStyle(
                fontSize: 15.1.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1C398E),
                height: 24 / 15.1,
                letterSpacing: 0,
              ),
            ),
            Text(
              SidebarConfig.getLocalizedLabel('fullyCompliant', localizations),
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
