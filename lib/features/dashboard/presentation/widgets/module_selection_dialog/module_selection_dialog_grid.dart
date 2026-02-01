import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/mixins/tab_index_mixin.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_utils.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/sub_module_button.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/employee_management_tab_provider.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_management_tab_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/time_management_tab_provider.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/workforce_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ModuleSelectionDialogGrid extends ConsumerWidget with TabIndexMixin {
  final List<SidebarItem> children;
  final Color parentColor;
  final DialogSizing sizing;

  const ModuleSelectionDialogGrid({super.key, required this.children, required this.parentColor, required this.sizing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final spec = _buildSubModuleSpec(sizing.breakpoint);

    return Expanded(
      child: Container(child: children.isEmpty ? _buildEmptyState() : _buildGrid(context, localizations, spec, ref)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No items available',
        style: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, AppLocalizations localizations, SubModuleSizeSpec spec, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: sizing.outerPadding),
      child: Wrap(
        spacing: sizing.gap,
        runSpacing: sizing.gap,
        alignment: sizing.wrapAlignment,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final childLabel = SidebarConfig.getLocalizedLabel(child.labelKey, localizations);

          final btn = DashboardButton(
            id: child.id,
            icon: child.svgPath ?? 'assets/icons/default_icon.svg',
            label: childLabel,
            color: parentColor,
            route: child.route ?? '',
            isMultiLine: childLabel.contains('\n') || childLabel.length > 20,
            badgeCount: index + 1,
            subtitle: child.subtitle,
          );

          return SizedBox(
            width: sizing.cardWidth,
            height: sizing.cardHeight,
            child: SubModuleButton(
              button: btn,
              onTap: () {
                if (btn.route.isNotEmpty) {
                  Navigator.of(context).pop();
                  context.go(btn.route);
                  _handleTabNavigation(btn.route, child.id, ref);
                }
              },
              spec: spec,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Handles tab navigation for routes that have tabs
  void _handleTabNavigation(String route, String itemId, WidgetRef ref) {
    if (route == AppRoutes.employees) {
      final tabIndex = getEmployeeManagementTabIndex(itemId);
      if (tabIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(employeeManagementTabStateProvider.notifier).setTabIndex(tabIndex);
        });
      }
    } else if (route == AppRoutes.timeManagement) {
      final tabIndex = getTimeManagementTabIndex(itemId);
      if (tabIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(timeManagementTabStateProvider.notifier).setTabIndex(tabIndex);
        });
      }
    } else if (route == AppRoutes.workforceStructure) {
      final tabIndex = getWorkforceStructureTabIndex(itemId);
      if (tabIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(workforceTabStateProvider.notifier).setTabIndex(tabIndex);
        });
      }
    } else if (route == AppRoutes.leaveManagement) {
      final tabIndex = getLeaveManagementTabIndex(itemId);
      if (tabIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(leaveManagementTabStateProvider.notifier).setTabIndex(tabIndex);
        });
      }
    }
  }

  SubModuleSizeSpec _buildSubModuleSpec(DialogBreakpoint bp) {
    return SubModuleSizeSpec(
      iconBox: bp == DialogBreakpoint.mobile ? 48 : (bp == DialogBreakpoint.tablet ? 64 : 80),
      iconSize: bp == DialogBreakpoint.mobile ? 24 : (bp == DialogBreakpoint.tablet ? 32 : 40),
      badgeBox: bp == DialogBreakpoint.mobile ? 20 : (bp == DialogBreakpoint.tablet ? 24 : 28),
      badgeFont: bp == DialogBreakpoint.mobile ? 10 : (bp == DialogBreakpoint.tablet ? 11 : 12),
      topPadding: bp == DialogBreakpoint.mobile ? 18 : (bp == DialogBreakpoint.tablet ? 20 : 22),
      gapAfterIcon: bp == DialogBreakpoint.mobile ? 10 : (bp == DialogBreakpoint.tablet ? 12 : 16),
      gapBeforeSubtitle: bp == DialogBreakpoint.mobile ? 6 : 12,
      titleFont: bp == DialogBreakpoint.mobile ? 14.5 : 15.6,
      subtitleFont: bp == DialogBreakpoint.mobile ? 11.2 : 11.8,
      titleHPad: bp == DialogBreakpoint.mobile ? 12 : (bp == DialogBreakpoint.tablet ? 16 : 26),
      subtitleHPad: bp == DialogBreakpoint.mobile ? 12 : (bp == DialogBreakpoint.tablet ? 16 : 30),
      breakpoint: bp,
    );
  }
}
