import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/dashboard_button_model.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_utils.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/sub_module_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ModuleSelectionDialogGrid extends StatelessWidget {
  final List<SidebarItem> children;
  final Color parentColor;
  final DialogSizing sizing;

  const ModuleSelectionDialogGrid({super.key, required this.children, required this.parentColor, required this.sizing});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final spec = _buildSubModuleSpec(sizing.breakpoint);

    return Expanded(
      child: Container(child: children.isEmpty ? _buildEmptyState() : _buildGrid(context, localizations, spec)),
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

  Widget _buildGrid(BuildContext context, AppLocalizations localizations, SubModuleSizeSpec spec) {
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
                }
              },
              spec: spec,
            ),
          );
        }).toList(),
      ),
    );
  }

  SubModuleSizeSpec _buildSubModuleSpec(DialogBreakpoint bp) {
    return SubModuleSizeSpec(
      iconBox: bp == DialogBreakpoint.mobile ? 60 : (bp == DialogBreakpoint.tablet ? 72 : 80),
      iconSize: bp == DialogBreakpoint.mobile ? 30 : (bp == DialogBreakpoint.tablet ? 34 : 40),
      badgeBox: bp == DialogBreakpoint.mobile ? 24 : (bp == DialogBreakpoint.tablet ? 26 : 28),
      badgeFont: bp == DialogBreakpoint.mobile ? 11 : 12,
      topPadding: bp == DialogBreakpoint.mobile ? 18 : (bp == DialogBreakpoint.tablet ? 20 : 22),
      gapAfterIcon: bp == DialogBreakpoint.mobile ? 12 : (bp == DialogBreakpoint.tablet ? 14 : 16),
      gapBeforeSubtitle: bp == DialogBreakpoint.mobile ? 8 : 12,
      titleFont: bp == DialogBreakpoint.mobile ? 14.5 : 15.6,
      subtitleFont: bp == DialogBreakpoint.mobile ? 11.2 : 11.8,
      titleHPad: bp == DialogBreakpoint.mobile ? 12 : (bp == DialogBreakpoint.tablet ? 16 : 26),
      subtitleHPad: bp == DialogBreakpoint.mobile ? 12 : (bp == DialogBreakpoint.tablet ? 16 : 30),
      breakpoint: bp,
    );
  }
}
