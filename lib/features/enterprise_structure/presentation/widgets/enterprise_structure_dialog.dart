import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/shimmer_widget.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/active_status_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_instructions_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dialog_header.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_area.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_shimmer.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_preview_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/warning_status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum EnterpriseStructureDialogMode { view, edit, create }

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

  static Future<void> showCreate(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const ProviderScope(
        child: EnterpriseStructureDialog(mode: EnterpriseStructureDialogMode.create),
      ),
    );
  }

  @override
  ConsumerState<EnterpriseStructureDialog> createState() =>
      _EnterpriseStructureDialogState();
}

class _EnterpriseStructureDialogState extends ConsumerState<EnterpriseStructureDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final _EditDialogParams _params;
  late final String _dialogId;

  bool _syncedApiToEditOnce = false;
  ProviderSubscription<EnterpriseStructureDialogState>? _apiSub;

  @override
  void initState() {
    super.initState();

    _dialogId = '${DateTime.now().millisecondsSinceEpoch}_${widget.hashCode}';

    final initialName =
    widget.mode == EnterpriseStructureDialogMode.create ? '' : (widget.structureName ?? '');
    final initialDescription =
    widget.mode == EnterpriseStructureDialogMode.create ? '' : (widget.description ?? '');

    _nameController = TextEditingController(text: initialName);
    _descriptionController = TextEditingController(text: initialDescription);

    _params = _EditDialogParams(
      structureName: initialName,
      description: initialDescription,
      initialLevels: widget.initialLevels ?? const <HierarchyLevel>[],
    );

    // ✅ Riverpod 2.6.x: listenManual is allowed in initState
    if (widget.mode != EnterpriseStructureDialogMode.view) {
      _apiSub = ref.listenManual<EnterpriseStructureDialogState>(
        enterpriseStructureDialogProvider(_dialogId),
            (previous, next) {
          if (!mounted) return;
          if (_syncedApiToEditOnce) return;
          if (next.isLoading) return;

          final loc = AppLocalizations.of(context);
          if (loc == null) return;

          final apiLevels = next.toHierarchyLevels(loc);
          if (apiLevels.isEmpty) return;

          final editState = ref.read(_editDialogProvider(_params));
          if (editState.levels.isNotEmpty) return;

          _syncedApiToEditOnce = true;
          ref.read(_editDialogProvider(_params).notifier).setLevels(apiLevels);
        },
      );
    }
  }

  @override
  void dispose() {
    _apiSub?.close();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getTitle(AppLocalizations l) {
    switch (widget.mode) {
      case EnterpriseStructureDialogMode.view:
        return l.viewEnterpriseStructureConfiguration;
      case EnterpriseStructureDialogMode.edit:
        return l.editEnterpriseStructureConfiguration;
      case EnterpriseStructureDialogMode.create:
        return l.createEnterpriseStructureConfiguration;
    }
  }

  String _getSubtitle(AppLocalizations l) {
    switch (widget.mode) {
      case EnterpriseStructureDialogMode.view:
        return l.reviewOrganizationalHierarchy;
      case EnterpriseStructureDialogMode.edit:
      case EnterpriseStructureDialogMode.create:
        return l.defineOrganizationalHierarchy;
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

    // API provider for this dialog instance
    final dialogState = ref.watch(enterpriseStructureDialogProvider(_dialogId));
    final apiLevels = dialogState.toHierarchyLevels(localizations);

    // Edit provider (only for edit/create)
    final editState =
    widget.mode != EnterpriseStructureDialogMode.view ? ref.watch(_editDialogProvider(_params)) : null;

    // ✅ SINGLE SOURCE OF TRUTH
    // View: API list
    // Edit/Create: provider list ONLY (prevents snap-back)
    final List<HierarchyLevel> levels = widget.mode == EnterpriseStructureDialogMode.view
        ? apiLevels
        : (editState?.levels ?? const <HierarchyLevel>[]);

    final structureName = widget.mode == EnterpriseStructureDialogMode.view
        ? (widget.structureName ?? '')
        : (editState?.structureName ?? '');

    final description = widget.mode == EnterpriseStructureDialogMode.view
        ? (widget.description ?? '')
        : (editState?.description ?? '');

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16.w : (isTablet ? 20.w : 24.w),
        vertical: isMobile ? 16.h : (isTablet ? 20.h : 24.h),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : (isTablet ? 700.w : 900.w),
          maxHeight: MediaQuery.of(context).size.height * (isMobile ? 0.95 : 0.9),
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
                padding: ResponsiveHelper.getResponsivePadding(
                  context,
                  mobile: EdgeInsetsDirectional.all(16.w),
                  tablet: EdgeInsetsDirectional.all(20.w),
                  web: EdgeInsetsDirectional.all(24.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    SizedBox(height: isMobile ? 16.h : 24.h),
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
                    SizedBox(height: isMobile ? 16.h : 24.h),
                    EnterpriseStructureTextField(
                      label: localizations.structureName,
                      isRequired: true,
                      controller: widget.mode == EnterpriseStructureDialogMode.view ? null : _nameController,
                      value: widget.mode == EnterpriseStructureDialogMode.view ? structureName : null,
                      readOnly: widget.mode == EnterpriseStructureDialogMode.view,
                      hintText: widget.mode == EnterpriseStructureDialogMode.create
                          ? localizations.structureNamePlaceholder
                          : null,
                      onChanged: widget.mode != EnterpriseStructureDialogMode.view
                          ? (value) => ref.read(_editDialogProvider(_params).notifier).updateStructureName(value)
                          : null,
                    ),
                    SizedBox(height: isMobile ? 12.h : 16.h),
                    EnterpriseStructureTextArea(
                      label: localizations.description,
                      isRequired: true,
                      controller: widget.mode == EnterpriseStructureDialogMode.view ? null : _descriptionController,
                      value: widget.mode == EnterpriseStructureDialogMode.view ? description : null,
                      readOnly: widget.mode == EnterpriseStructureDialogMode.view,
                      hintText: widget.mode == EnterpriseStructureDialogMode.create
                          ? localizations.descriptionPlaceholder
                          : null,
                      onChanged: widget.mode != EnterpriseStructureDialogMode.view
                          ? (value) => ref.read(_editDialogProvider(_params).notifier).updateDescription(value)
                          : null,
                    ),
                    SizedBox(height: isMobile ? 16.h : 24.h),

                    if (levels.isEmpty && dialogState.isLoading)
                      _buildShimmerLoading(context, localizations, isDark, isMobile)
                    else if (levels.isEmpty && dialogState.hasError)
                      Padding(
                        padding: EdgeInsetsDirectional.all(16.w),
                        child: Text(
                          dialogState.errorMessage ?? 'Failed to load structure levels',
                          style: TextStyle(fontSize: 13.sp, color: Colors.red),
                        ),
                      )
                    else if (levels.isEmpty && !dialogState.isLoading)
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
                        _buildOrganizationalHierarchyLevelsSection(
                          context,
                          localizations,
                          isDark,
                          levels,
                          editState,
                          dialogState,
                        ),
                    SizedBox(height: 24.h),
                    _buildHierarchyPreviewSection(
                        context, localizations, isDark, levels),

                    SizedBox(height: isMobile ? 16.h : 24.h),
                    ConfigurationSummaryWidget(
                      totalLevels: levels.length,
                      activeLevels: levels.where((l) => l.isActive).length,
                      hierarchyDepth: levels.where((l) => l.isActive).length,
                      topLevel: levels.isNotEmpty ? levels.first.name : '',
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(context, localizations, isDark, editState),
          ],
        ),
      ),
    );
  }

  /// Builds shimmer loading skeleton for hierarchy levels
  Widget _buildShimmerLoading(
      BuildContext context,
      AppLocalizations localizations,
      bool isDark,
      bool isMobile,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(
          width: 200.w,
          height: 20.h,
          borderRadius: 4.r,
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),
        ...List.generate(
          5,
              (index) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.h),
            child: const HierarchyLevelShimmer(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationalHierarchyLevelsSection(
      BuildContext context,
      AppLocalizations localizations,
      bool isDark,
      List<HierarchyLevel> levels,
      EditEnterpriseStructureState? state,
      EnterpriseStructureDialogState dialogState,
      ) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMobile
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.organizationalHierarchyLevels,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              ),
            ),
            if (widget.mode != EnterpriseStructureDialogMode.view) ...[
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  final api = dialogState.toHierarchyLevels(localizations);
                  if (api.isNotEmpty) {
                    ref.read(_editDialogProvider(_params).notifier).resetToDefault(api);
                  }
                },
                child: Text(
                  localizations.resetToDefault,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
                ),
              ),
            ],
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.organizationalHierarchyLevels,
              style: TextStyle(
                fontSize: isTablet ? 14.5.sp : 15.4.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
              ),
            ),
            if (widget.mode != EnterpriseStructureDialogMode.view)
              GestureDetector(
                onTap: () {
                  final api = dialogState.toHierarchyLevels(localizations);
                  if (api.isNotEmpty) {
                    ref.read(_editDialogProvider(_params).notifier).resetToDefault(api);
                  }
                },
                child: Text(
                  localizations.resetToDefault,
                  style: TextStyle(
                    fontSize: isTablet ? 12.5.sp : 13.6.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isMobile ? 12.h : 16.h),

        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: levels.length,
          onReorder: (oldIndex, newIndex) {
            if (widget.mode == EnterpriseStructureDialogMode.view) return;

            if (oldIndex < 0 || oldIndex >= levels.length) return;
            if (levels[oldIndex].isMandatory) return;

            // ReorderableListView gives insertion index AFTER removal
            int target = newIndex;
            if (target > oldIndex) target -= 1;

            // Clamp
            if (target < 0) target = 0;
            if (target >= levels.length) target = levels.length - 1;

            // ✅ If dropping onto a mandatory index, move target to nearest non-mandatory
            if (levels[target].isMandatory) {
              final int dir = (target > oldIndex) ? 1 : -1;

              int scan = target;
              while (scan >= 0 && scan < levels.length && levels[scan].isMandatory) {
                scan += dir;
              }

              // If no slot found in that direction, try the other direction
              if (scan < 0 || scan >= levels.length) {
                scan = target;
                while (scan >= 0 && scan < levels.length && levels[scan].isMandatory) {
                  scan -= dir;
                }
              }

              // If still no valid target, cancel reorder
              if (scan < 0 || scan >= levels.length) return;

              target = scan;
            }

            // ✅ Now reorder using the corrected target
            ref.read(_editDialogProvider(_params).notifier).reorderLevels(oldIndex, target);
          },

          itemBuilder: (context, index) {
            final level = levels[index];

            final card = HierarchyLevelCard(
              name: level.name,
              icon: level.icon,
              levelNumber: level.level,
              isMandatory: level.isMandatory,
              isActive: level.isActive,
              canMoveUp: index > 0,
              canMoveDown: index < levels.length - 1,
              onMoveUp: widget.mode == EnterpriseStructureDialogMode.view
                  ? null
                  : () => ref.read(_editDialogProvider(_params).notifier).moveLevelUp(index),
              onMoveDown: widget.mode == EnterpriseStructureDialogMode.view
                  ? null
                  : () => ref.read(_editDialogProvider(_params).notifier).moveLevelDown(index),
              onToggleActive: widget.mode == EnterpriseStructureDialogMode.view
                  ? null
                  : (_) => ref.read(_editDialogProvider(_params).notifier).toggleLevelActive(index),
            );

            // ✅ Mandatory: NOT draggable (no drag handle wrapper)
            if (level.isMandatory || widget.mode == EnterpriseStructureDialogMode.view) {
              return Padding(
                key: ValueKey(level.id),
                padding: EdgeInsetsDirectional.only(bottom: 12.h),
                child: card,
              );
            }

            // ✅ Non-mandatory: draggable
            return Padding(
              key: ValueKey(level.id),
              padding: EdgeInsetsDirectional.only(bottom: 12.h),
              child: ReorderableDragStartListener(
                index: index,
                child: card,
              ),
            );
          },
        ),
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
    // Keep your original footer code here (unchanged).
    return const SizedBox.shrink();
  }
}

final _editDialogProvider = StateNotifierProvider.autoDispose.family<
    EditEnterpriseStructureNotifier,
    EditEnterpriseStructureState,
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
