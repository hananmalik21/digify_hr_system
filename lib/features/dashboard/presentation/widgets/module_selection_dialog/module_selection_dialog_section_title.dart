import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/dashboard/presentation/widgets/module_selection_dialog/module_selection_dialog_utils.dart';
import 'package:flutter/material.dart';

class ModuleSelectionDialogSectionTitle extends StatelessWidget {
  final String title;
  final DialogSizing sizing;

  const ModuleSelectionDialogSectionTitle({super.key, required this.title, required this.sizing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: sizing.outerPadding,
        end: sizing.outerPadding,
        top: 24.0,
        bottom: 40.0,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Text('$title Modules', style: context.textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary)),
    );
  }
}
