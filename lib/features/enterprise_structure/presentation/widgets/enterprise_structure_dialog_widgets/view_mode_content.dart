import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'enterprise_structure_dialog_mode.dart';
import 'enterprise_structure_dialog_providers.dart';
import 'hierarchy_preview_section.dart';
import 'organizational_hierarchy_levels_section.dart';

class ViewModeContent extends StatelessWidget {
  final AppLocalizations localizations;
  final List<HierarchyLevel> levels;
  final String structureName;
  final String description;
  final EditDialogParams params;

  const ViewModeContent({
    super.key,
    required this.localizations,
    required this.levels,
    required this.structureName,
    required this.description,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyTextField(
          labelText: localizations.structureName,
          isRequired: true,
          initialValue: structureName,
          readOnly: true,
          filled: true,
        ),
        Gap(16.h),
        DigifyTextField(
          labelText: localizations.description,
          isRequired: true,
          initialValue: description,
          readOnly: true,
          maxLines: 4,
          filled: true,
        ),
        Gap(24.h),
        if (levels.isEmpty)
          Padding(
            padding: EdgeInsetsDirectional.all(16.w),
            child: Center(
              child: Text(
                'No structure levels found',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                ),
              ),
            ),
          )
        else
          OrganizationalHierarchyLevelsSection(
            mode: EnterpriseStructureDialogMode.view,
            levels: levels,
            state: null,
            dialogState: null,
            params: params,
            editDialogProvider: editEnterpriseStructureDialogProvider,
          ),
        Gap(12.h),
        HierarchyPreviewSection(levels: levels),
        Gap(24.h),
        ConfigurationSummaryWidget(
          totalLevels: levels.length,
          activeLevels: levels.where((l) => l.isActive).length,
          hierarchyDepth: levels.where((l) => l.isActive).length,
          topLevel: levels.isNotEmpty ? levels.first.name : '',
        ),
      ],
    );
  }
}
