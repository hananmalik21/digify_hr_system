import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/active_status_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_instructions_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dialog_header.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_area.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditEnterpriseStructureDialog extends ConsumerStatefulWidget {
  final String structureName;
  final String description;
  final List<HierarchyLevel> initialLevels;

  const EditEnterpriseStructureDialog({
    super.key,
    required this.structureName,
    required this.description,
    required this.initialLevels,
  });

  static Future<void> show(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        child: EditEnterpriseStructureDialog(
          structureName: structureName,
          description: description,
          initialLevels: initialLevels,
        ),
      ),
    );
  }

  @override
  ConsumerState<EditEnterpriseStructureDialog> createState() =>
      _EditEnterpriseStructureDialogState();
}

final _editDialogProvider = StateNotifierProvider.autoDispose
    .family<EditEnterpriseStructureNotifier, EditEnterpriseStructureState,
        _EditDialogParams>(
  (ref, params) => EditEnterpriseStructureNotifier(
    structureName: params.structureName,
    description: params.description,
    initialLevels: params.initialLevels,
  ),
);

class _EditDialogParams {
  final String structureName;
  final String description;
  final List<HierarchyLevel> initialLevels;

  _EditDialogParams({
    required this.structureName,
    required this.description,
    required this.initialLevels,
  });
}

class _EditEnterpriseStructureDialogState
    extends ConsumerState<EditEnterpriseStructureDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final _EditDialogParams _params;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.structureName);
    _descriptionController = TextEditingController(text: widget.description);
    _params = _EditDialogParams(
      structureName: widget.structureName,
      description: widget.description,
      initialLevels: widget.initialLevels,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(_editDialogProvider(_params));

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
              title: localizations.editEnterpriseStructureConfiguration,
              subtitle: localizations.defineOrganizationalHierarchy,
              iconPath: 'assets/icons/edit_enterprise_icon.svg',
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
                      controller: _nameController,
                      onChanged: (value) {
                        ref.read(_editDialogProvider(_params).notifier)
                            .updateStructureName(value);
                      },
                    ),
                    SizedBox(height: 16.h),
                    EnterpriseStructureTextArea(
                      label: localizations.description,
                      isRequired: true,
                      controller: _descriptionController,
                      onChanged: (value) {
                        ref.read(_editDialogProvider(_params).notifier)
                            .updateDescription(value);
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildOrganizationalHierarchyLevelsSection(
                        context, localizations, isDark, state),
                    SizedBox(height: 24.h),
                    _buildHierarchyPreviewSection(
                        context, localizations, isDark, state),
                    SizedBox(height: 24.h),
                    ConfigurationSummaryWidget(
                      totalLevels: state.totalLevels,
                      activeLevels: state.activeLevels,
                      hierarchyDepth: state.hierarchyDepth,
                      topLevel: state.topLevel,
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
    EditEnterpriseStructureState state,
  ) {
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
                ref.read(_editDialogProvider(_params).notifier)
                    .resetToDefault();
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
        ...state.levels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.h),
            child: HierarchyLevelCard(
              name: level.name,
              icon: level.icon,
              levelNumber: level.level,
              isMandatory: level.isMandatory,
              isActive: level.isActive,
              canMoveUp: index > 0,
              canMoveDown: index < state.levels.length - 1,
              onMoveUp: () {
                ref.read(_editDialogProvider(_params).notifier)
                    .moveLevelUp(index);
              },
              onMoveDown: () {
                ref.read(_editDialogProvider(_params).notifier)
                    .moveLevelDown(index);
              },
              onToggleActive: (value) {
                ref.read(_editDialogProvider(_params).notifier)
                    .toggleLevelActive(index);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHierarchyPreviewSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    EditEnterpriseStructureState state,
  ) {
    final previewLevels = state.levels
        .where((level) => level.isActive)
        .map((level) => HierarchyPreviewLevel(
              name: level.name,
              icon: level.previewIcon,
              level: level.level,
              width: _getPreviewWidth(level.level, state.levels.length),
            ))
        .toList();

    return HierarchyPreviewWidget(levels: previewLevels);
  }

  double _getPreviewWidth(int level, int totalLevels) {
    // Calculate width based on level position
    final baseWidth = 814.0;
    final widthDecrement = 24.0;
    return baseWidth - (widthDecrement * (level - 1));
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
                        assetPath: 'assets/icons/preview_structure_icon.svg',
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
                  // TODO: Save Configuration
                  final state = ref.read(_editDialogProvider(_params));
                  debugPrint('Saving: ${state.structureName}');
                  Navigator.of(context).pop();
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
                        assetPath: 'assets/icons/save_config_icon.svg',
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

