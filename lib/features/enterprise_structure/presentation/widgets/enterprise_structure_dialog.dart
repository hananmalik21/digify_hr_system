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
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/warning_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum EnterpriseStructureDialogMode {
  view,
  edit,
  create,
}

class EnterpriseStructureDialog extends ConsumerStatefulWidget {
  final EnterpriseStructureDialogMode mode;
  final String? structureName;
  final String? description;
  final List<HierarchyLevel>? initialLevels;

  const EnterpriseStructureDialog({
    super.key,
    required this.mode,
    this.structureName,
    this.description,
    this.initialLevels,
  });

  // View mode factory
  static Future<void> showView(
    BuildContext context, {
    required String structureName,
    required String description,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => EnterpriseStructureDialog(
        mode: EnterpriseStructureDialogMode.view,
        structureName: structureName,
        description: description,
      ),
    );
  }

  // Edit mode factory
  static Future<void> showEdit(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        child: EnterpriseStructureDialog(
          mode: EnterpriseStructureDialogMode.edit,
          structureName: structureName,
          description: description,
          initialLevels: initialLevels,
        ),
      ),
    );
  }

  // Create mode factory
  static Future<void> showCreate(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        child: EnterpriseStructureDialog(
          mode: EnterpriseStructureDialogMode.create,
        ),
      ),
    );
  }

  @override
  ConsumerState<EnterpriseStructureDialog> createState() =>
      _EnterpriseStructureDialogState();
}

class _EnterpriseStructureDialogState
    extends ConsumerState<EnterpriseStructureDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final _EditDialogParams _params;

  @override
  void initState() {
    super.initState();

    // Initialize controllers based on mode
    final initialName = widget.mode == EnterpriseStructureDialogMode.create
        ? ''
        : (widget.structureName ?? '');
    final initialDescription = widget.mode == EnterpriseStructureDialogMode.create
        ? ''
        : (widget.description ?? '');

    _nameController = TextEditingController(text: initialName);
    _descriptionController = TextEditingController(text: initialDescription);

    // Initialize levels based on mode - will be set in build when we have context
    final initialLevels = widget.initialLevels ?? [];

    _params = _EditDialogParams(
      structureName: initialName,
      description: initialDescription,
      initialLevels: initialLevels,
    );
  }

  List<HierarchyLevel> _getDefaultLevels(AppLocalizations localizations) {
    return [
      HierarchyLevel(
        id: 'company',
        name: localizations.company,
        icon: 'assets/icons/company_icon_small.svg',
        level: 1,
        isMandatory: true,
        isActive: true,
        previewIcon: 'assets/icons/company_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'division',
        name: localizations.division,
        icon: 'assets/icons/division_icon_small.svg',
        level: 2,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/division_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'business_unit',
        name: localizations.businessUnit,
        icon: 'assets/icons/business_unit_icon_small.svg',
        level: 3,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/business_unit_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'department',
        name: localizations.department,
        icon: 'assets/icons/department_icon_small.svg',
        level: 4,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/department_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'section',
        name: localizations.section,
        icon: 'assets/icons/section_icon_small.svg',
        level: 5,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/section_icon_preview.svg',
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getTitle(AppLocalizations localizations) {
    switch (widget.mode) {
      case EnterpriseStructureDialogMode.view:
        return localizations.viewEnterpriseStructureConfiguration;
      case EnterpriseStructureDialogMode.edit:
        return localizations.editEnterpriseStructureConfiguration;
      case EnterpriseStructureDialogMode.create:
        return localizations.createEnterpriseStructureConfiguration;
    }
  }

  String _getSubtitle(AppLocalizations localizations) {
    switch (widget.mode) {
      case EnterpriseStructureDialogMode.view:
        return localizations.reviewOrganizationalHierarchy;
      case EnterpriseStructureDialogMode.edit:
      case EnterpriseStructureDialogMode.create:
        return localizations.defineOrganizationalHierarchy;
    }
  }

  String _getIconPath() {
    switch (widget.mode) {
      case EnterpriseStructureDialogMode.view:
        return 'assets/icons/view_enterprise_icon.svg';
      case EnterpriseStructureDialogMode.edit:
        return 'assets/icons/edit_enterprise_icon.svg';
      case EnterpriseStructureDialogMode.create:
        return 'assets/icons/create_enterprise_icon.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    // Get state for edit/create modes
    final state = widget.mode != EnterpriseStructureDialogMode.view
        ? ref.watch(_editDialogProvider(_params))
        : null;

    // For view mode, use widget values; for edit/create, use state
    final structureName = widget.mode == EnterpriseStructureDialogMode.view
        ? widget.structureName ?? ''
        : (state?.structureName ?? '');
    final description = widget.mode == EnterpriseStructureDialogMode.view
        ? widget.description ?? ''
        : (state?.description ?? '');
    
    // Get levels - use state for edit/create, default for view/create
    final defaultLevels = _getDefaultLevels(localizations);
    final levels = widget.mode == EnterpriseStructureDialogMode.view
        ? defaultLevels
        : (state?.levels ?? defaultLevels);

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
              title: _getTitle(localizations),
              subtitle: _getSubtitle(localizations),
              iconPath: _getIconPath(),
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show warning card for create mode, active card for view/edit
                    if (widget.mode == EnterpriseStructureDialogMode.create)
                      WarningStatusCard(
                        title: localizations.noConfigurationFound,
                        message: localizations.pleaseConfigureEnterpriseStructure,
                      )
                    else
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
                      controller: widget.mode == EnterpriseStructureDialogMode.view
                          ? null
                          : _nameController,
                      value: widget.mode == EnterpriseStructureDialogMode.view
                          ? structureName
                          : null,
                      readOnly: widget.mode == EnterpriseStructureDialogMode.view,
                      hintText: widget.mode == EnterpriseStructureDialogMode.create
                          ? localizations.structureNamePlaceholder
                          : null,
                      onChanged: widget.mode != EnterpriseStructureDialogMode.view
                          ? (value) {
                              ref.read(_editDialogProvider(_params).notifier)
                                  .updateStructureName(value);
                            }
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    EnterpriseStructureTextArea(
                      label: localizations.description,
                      isRequired: true,
                      controller: widget.mode == EnterpriseStructureDialogMode.view
                          ? null
                          : _descriptionController,
                      value: widget.mode == EnterpriseStructureDialogMode.view
                          ? description
                          : null,
                      readOnly: widget.mode == EnterpriseStructureDialogMode.view,
                      hintText: widget.mode == EnterpriseStructureDialogMode.create
                          ? localizations.descriptionPlaceholder
                          : null,
                      onChanged: widget.mode != EnterpriseStructureDialogMode.view
                          ? (value) {
                              ref.read(_editDialogProvider(_params).notifier)
                                  .updateDescription(value);
                            }
                          : null,
                    ),
                    SizedBox(height: 24.h),
                    _buildOrganizationalHierarchyLevelsSection(
                        context, localizations, isDark, levels, state),
                    SizedBox(height: 24.h),
                    _buildHierarchyPreviewSection(
                        context, localizations, isDark, levels),
                    SizedBox(height: 24.h),
                    ConfigurationSummaryWidget(
                      totalLevels: levels.length,
                      activeLevels: levels.where((l) => l.isActive).length,
                      hierarchyDepth: levels.where((l) => l.isActive).length,
                      topLevel: levels.first.name,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(context, localizations, isDark, state),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationalHierarchyLevelsSection(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    List<HierarchyLevel> levels,
    EditEnterpriseStructureState? state,
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
            if (widget.mode != EnterpriseStructureDialogMode.view)
              GestureDetector(
                onTap: () {
                  ref.read(_editDialogProvider(_params).notifier).resetToDefault();
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
        ...levels.asMap().entries.map((entry) {
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
              canMoveDown: index < levels.length - 1,
              onMoveUp: widget.mode == EnterpriseStructureDialogMode.view
                  ? null
                  : () {
                      ref.read(_editDialogProvider(_params).notifier).moveLevelUp(index);
                    },
              onMoveDown: widget.mode == EnterpriseStructureDialogMode.view
                  ? null
                  : () {
                      ref.read(_editDialogProvider(_params).notifier).moveLevelDown(index);
                    },
              onToggleActive: widget.mode == EnterpriseStructureDialogMode.view
                  ? null
                  : (value) {
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
    List<HierarchyLevel> levels,
  ) {
    final previewLevels = levels
        .where((level) => level.isActive)
        .map((level) => HierarchyPreviewLevel(
              name: level.name,
              icon: level.previewIcon,
              level: level.level,
              width: _getPreviewWidth(level.level, levels.length),
            ))
        .toList();

    return HierarchyPreviewWidget(levels: previewLevels);
  }

  double _getPreviewWidth(int level, int totalLevels) {
    final baseWidth = 814.0;
    final widthDecrement = 24.0;
    return baseWidth - (widthDecrement * (level - 1));
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations localizations,
    bool isDark,
    EditEnterpriseStructureState? state,
  ) {
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
              if (widget.mode != EnterpriseStructureDialogMode.view) ...[
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
              ],
              GestureDetector(
                onTap: widget.mode == EnterpriseStructureDialogMode.view
                    ? null
                    : () {
                        // TODO: Save Configuration
                        if (state != null) {
                          debugPrint('Saving: ${state.structureName}');
                        }
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
                        assetPath: widget.mode == EnterpriseStructureDialogMode.create
                            ? 'assets/icons/save_config_icon.svg'
                            : 'assets/icons/save_config_icon.svg',
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

