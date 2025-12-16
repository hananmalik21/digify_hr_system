import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/active_status_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_instructions_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dialog_header.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_area.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewEnterpriseStructureDialog extends StatelessWidget {
  final String structureName;
  final String description;

  const ViewEnterpriseStructureDialog({
    super.key,
    required this.structureName,
    required this.description,
  });

  static Future<void> show(
    BuildContext context, {
    required String structureName,
    required String description,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ViewEnterpriseStructureDialog(
        structureName: structureName,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 900.w,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EnterpriseStructureDialogHeader(
              title: localizations.viewEnterpriseStructureConfiguration,
              subtitle: localizations.reviewOrganizationalHierarchy,
              iconPath: 'assets/icons/view_enterprise_icon.svg',
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActiveStatusCard(
                      title: localizations.structureConfigurationActive,
                      message: localizations.enterpriseStructureActiveMessage,
                    ),
                    SizedBox(height: 24.h),
                    ConfigurationInstructionsCard(
                      title: localizations.configurationInstructions,
                      instructions: [
                        localizations.companyMandatoryInstruction,
                        localizations.enableDisableLevelsInstruction,
                        localizations.useArrowsInstruction,
                        localizations.orderDeterminesRelationshipsInstruction,
                        localizations.changesAffectComponentsInstruction,
                      ],
                      boldText: localizations.company,
                    ),
                    SizedBox(height: 24.h),
                    EnterpriseStructureTextField(
                      label: localizations.structureName,
                      isRequired: true,
                      value: structureName,
                      readOnly: true,
                    ),
                    SizedBox(height: 16.h),
                    EnterpriseStructureTextArea(
                      label: localizations.description,
                      isRequired: true,
                      value: description,
                      readOnly: true,
                    ),
                    SizedBox(height: 24.h),
                    _buildOrganizationalHierarchyLevelsSection(
                        context, localizations, isDark),
                    SizedBox(height: 24.h),
                    _buildHierarchyPreviewSection(
                        context, localizations, isDark),
                    SizedBox(height: 24.h),
                    ConfigurationSummaryWidget(
                      totalLevels: 5,
                      activeLevels: 5,
                      hierarchyDepth: 5,
                      topLevel: localizations.company,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(context, localizations, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationalHierarchyLevelsSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final levels = [
      {
        'name': localizations.company,
        'icon': 'assets/icons/company_icon_small.svg',
        'level': 1,
        'isMandatory': true,
        'isActive': true,
        'canMoveUp': false,
        'canMoveDown': true,
      },
      {
        'name': localizations.division,
        'icon': 'assets/icons/division_icon_small.svg',
        'level': 2,
        'isMandatory': false,
        'isActive': true,
        'canMoveUp': true,
        'canMoveDown': true,
      },
      {
        'name': localizations.businessUnit,
        'icon': 'assets/icons/business_unit_icon_small.svg',
        'level': 3,
        'isMandatory': false,
        'isActive': true,
        'canMoveUp': true,
        'canMoveDown': true,
      },
      {
        'name': localizations.department,
        'icon': 'assets/icons/department_icon_small.svg',
        'level': 4,
        'isMandatory': false,
        'isActive': true,
        'canMoveUp': true,
        'canMoveDown': true,
      },
      {
        'name': localizations.section,
        'icon': 'assets/icons/section_icon_small.svg',
        'level': 5,
        'isMandatory': false,
        'isActive': true,
        'canMoveUp': true,
        'canMoveDown': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.organizationalHierarchyLevels,
              style: TextStyle(
                fontSize: 15.4.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : const Color(0xFF101828),
                height: 24 / 15.4,
                letterSpacing: 0,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Reset to Default (read-only in view mode)
              },
              child: Text(
                localizations.resetToDefault,
                style: TextStyle(
                  fontSize: 13.6.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                  height: 20 / 13.6,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...levels.map((level) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: 12.h),
              child: HierarchyLevelCard(
                name: level['name'] as String,
                icon: level['icon'] as String,
                levelNumber: level['level'] as int,
                isMandatory: level['isMandatory'] as bool,
                isActive: level['isActive'] as bool,
                canMoveUp: level['canMoveUp'] as bool,
                canMoveDown: level['canMoveDown'] as bool,
                // Read-only mode - no callbacks
                onMoveUp: null,
                onMoveDown: null,
                onToggleActive: null,
              ),
            )),
      ],
    );
  }

  Widget _buildHierarchyPreviewSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
  ) {
    final previewLevels = [
      HierarchyPreviewLevel(
        name: localizations.company,
        icon: 'assets/icons/company_icon_preview.svg',
        level: 1,
        width: 814.0,
      ),
      HierarchyPreviewLevel(
        name: localizations.division,
        icon: 'assets/icons/division_icon_preview.svg',
        level: 2,
        width: 790.0,
      ),
      HierarchyPreviewLevel(
        name: localizations.businessUnit,
        icon: 'assets/icons/business_unit_icon_preview.svg',
        level: 3,
        width: 766.0,
      ),
      HierarchyPreviewLevel(
        name: localizations.department,
        icon: 'assets/icons/department_icon_preview.svg',
        level: 4,
        width: 742.0,
      ),
      HierarchyPreviewLevel(
        name: localizations.section,
        icon: 'assets/icons/section_icon_preview.svg',
        level: 5,
        width: 718.0,
      ),
    ];

    return HierarchyPreviewWidget(levels: previewLevels);
  }

  Widget _buildFooter(
      BuildContext context, AppLocalizations localizations, bool isDark) {
    return Container(
      padding: EdgeInsetsDirectional.only(
          start: 24.w, end: 24.w, top: 25.h, bottom: 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFF9FAFB),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 25.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                border: Border.all(
                  color: isDark
                      ? AppColors.inputBorderDark
                      : const Color(0xFFD1D5DC),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : const Color(0xFF364153),
                  height: 24 / 15.3,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Preview structure
                },
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : const Color(0xFF4A5565),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIconWidget(
                        assetPath: 'assets/icons/preview_icon.svg',
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        localizations.previewStructure,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 24 / 15.3,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  // TODO: Save Configuration (read-only in view mode)
                },
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9810FA),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgIconWidget(
                        assetPath: 'assets/icons/save_icon.svg',
                        size: 20.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        localizations.saveConfiguration,
                        style: TextStyle(
                          fontSize: 15.3.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 24 / 15.3,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
