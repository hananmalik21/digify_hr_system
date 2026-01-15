import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/configs/sidebar_config.dart';
import 'package:digify_hr_system/core/navigation/models/sidebar_item.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_grid.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_header.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_section_title.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModuleSelectionDialog extends StatelessWidget {
  final SidebarItem module;
  final Color parentColor;

  const ModuleSelectionDialog({super.key, required this.module, required this.parentColor});

  @override
  Widget build(BuildContext context) {
    final children = module.children ?? [];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final sizing = DialogSizing.calculate(constraints.maxWidth, constraints.maxHeight);
              final moduleLabel = SidebarConfig.getLocalizedLabel(module.labelKey, AppLocalizations.of(context)!);
              final cleanTitle = moduleLabel.replaceAll('\n', ' ');

              return Container(
                width: sizing.dialogWidth,
                constraints: BoxConstraints(maxHeight: sizing.dialogHeight),
                decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(24.r)),
                child: Column(
                  children: [
                    ModuleSelectionDialogHeader(module: module, childrenCount: children.length, sizing: sizing),
                    ModuleSelectionDialogSectionTitle(title: cleanTitle, sizing: sizing),
                    ModuleSelectionDialogGrid(children: children, parentColor: parentColor, sizing: sizing),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
