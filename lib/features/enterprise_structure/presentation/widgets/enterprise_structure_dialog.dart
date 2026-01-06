import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_dropdown.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_dialog_header.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_area.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/enterprise_structure_text_field.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog_widgets/dialog_footer.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog_widgets/hierarchy_preview_section.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog_widgets/organizational_hierarchy_levels_section.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog_widgets/shimmer_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

enum EnterpriseStructureDialogMode { view, edit, create }

class EnterpriseStructureDialog extends ConsumerStatefulWidget {
  final EnterpriseStructureDialogMode mode;
  final String? structureName;
  final String? description;
  final List<HierarchyLevel>? initialLevels;
  final int? enterpriseId;
  final int? structureId; // For update operations
  final bool? isActive; // Current active status
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const EnterpriseStructureDialog({
    super.key,
    required this.mode,
    required this.provider,
    this.structureName,
    this.description,
    this.initialLevels,
    this.enterpriseId,
    this.structureId,
    this.isActive,
  });

  static Future<void> showView(
    BuildContext context, {
    required String structureName,
    required String description,
    int? enterpriseId,
    List<HierarchyLevel>? initialLevels,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => EnterpriseStructureDialog(
        mode: EnterpriseStructureDialogMode.view,
        structureName: structureName,
        description: description,
        enterpriseId: enterpriseId,
        initialLevels: initialLevels,
        provider: provider,
      ),
    );
  }

  static Future<void> showEdit(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    int? enterpriseId,
    int? structureId,
    bool? isActive,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
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
          enterpriseId: enterpriseId,
          structureId: structureId,
          isActive: isActive,
          provider: provider,
        ),
      ),
    );
  }

  static Future<void> showCreate(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        child: EnterpriseStructureDialog(mode: EnterpriseStructureDialogMode.create, provider: provider),
      ),
    );
  }

  @override
  ConsumerState<EnterpriseStructureDialog> createState() => _EnterpriseStructureDialogState();
}

class _EnterpriseStructureDialogState extends ConsumerState<EnterpriseStructureDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final EditDialogParams _params;
  late final String _dialogId;

  bool _syncedApiToEditOnce = false;
  ProviderSubscription<EnterpriseStructureDialogState>? _apiSub;

  final saveEnterpriseStructureProvider =
      StateNotifierProvider.autoDispose<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>((ref) {
        final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
        return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
      });

  final _editDialogProvider = StateNotifierProvider.autoDispose
      .family<EditEnterpriseStructureNotifier, EditEnterpriseStructureState, EditDialogParams>(
        (ref, params) => EditEnterpriseStructureNotifier(
          structureName: params.structureName,
          description: params.description,
          initialLevels: params.initialLevels,
          selectedEnterpriseId: params.selectedEnterpriseId,
          isActive: params.isActive,
        ),
      );

  @override
  void initState() {
    super.initState();

    _dialogId = '${DateTime.now().millisecondsSinceEpoch}_${widget.hashCode}';

    final initialName = widget.mode == EnterpriseStructureDialogMode.create ? '' : (widget.structureName ?? '');
    final initialDescription = widget.mode == EnterpriseStructureDialogMode.create ? '' : (widget.description ?? '');

    _nameController = TextEditingController(text: initialName);
    _descriptionController = TextEditingController(text: initialDescription);

    _params = EditDialogParams(
      structureName: initialName,
      description: initialDescription,
      initialLevels: widget.initialLevels ?? const <HierarchyLevel>[],
      selectedEnterpriseId: widget.enterpriseId,
      // Auto-select enterprise from structure
      isActive: widget.isActive ?? true, // Default to true for create mode
    );

    // Initialize edit provider with structure's levels in edit mode
    if (widget.mode == EnterpriseStructureDialogMode.edit &&
        widget.initialLevels != null &&
        widget.initialLevels!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final editNotifier = ref.read(_editDialogProvider(_params).notifier);
          editNotifier.setLevels(widget.initialLevels!);
          if (widget.enterpriseId != null) {
            editNotifier.updateSelectedEnterprise(widget.enterpriseId);
          }
          if (widget.isActive != null) {
            editNotifier.updateIsActive(widget.isActive!);
          }
        }
      });
    }

    // Auto-select enterprise in create mode if provided
    if (widget.mode == EnterpriseStructureDialogMode.create && widget.enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(_editDialogProvider(_params).notifier).updateSelectedEnterprise(widget.enterpriseId);
        }
      });
    }

    // ✅ Only load from API in create mode
    // In view/edit mode, use the structure's levels (initialLevels)
    if (widget.mode == EnterpriseStructureDialogMode.create) {
      _apiSub = ref.listenManual<EnterpriseStructureDialogState>(enterpriseStructureDialogProvider(_dialogId), (
        previous,
        next,
      ) {
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
      });
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

    // API provider for this dialog instance (only used in create mode)
    final dialogState = widget.mode == EnterpriseStructureDialogMode.create
        ? ref.watch(enterpriseStructureDialogProvider(_dialogId))
        : null;
    final apiLevels = dialogState?.toHierarchyLevels(localizations) ?? [];

    // Edit provider (only for edit/create)
    final editState = widget.mode != EnterpriseStructureDialogMode.view
        ? ref.watch(_editDialogProvider(_params))
        : null;

    // ✅ SINGLE SOURCE OF TRUTH
    // View: Use structure's levels (initialLevels)
    // Edit: Use structure's levels from edit provider (initialized from initialLevels)
    // Create: Use API levels synced to edit provider
    final List<HierarchyLevel> levels;
    if (widget.mode == EnterpriseStructureDialogMode.view) {
      // View mode: use the structure's levels directly
      levels = widget.initialLevels ?? const <HierarchyLevel>[];
    } else if (widget.mode == EnterpriseStructureDialogMode.edit) {
      // Edit mode: use edit provider levels (initialized from structure's levels)
      levels = editState?.levels ?? widget.initialLevels ?? const <HierarchyLevel>[];
    } else {
      // Create mode: use API levels synced to edit provider
      levels = editState?.levels ?? apiLevels;
    }

    final structureName = widget.mode == EnterpriseStructureDialogMode.view
        ? (widget.structureName ?? '')
        : (editState?.structureName ?? '');

    final description = widget.mode == EnterpriseStructureDialogMode.view
        ? (widget.description ?? '')
        : (editState?.description ?? '');

    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
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
                      // if (widget.mode == EnterpriseStructureDialogMode.create)
                      //   WarningStatusCard(
                      //     title: localizations.noConfigurationFound,
                      //     message: localizations.pleaseConfigureEnterpriseStructure,
                      //   )
                      // else
                      //   ActiveStatusCard(
                      //     title: localizations.structureConfigurationActive,
                      //     message: localizations.enterpriseStructureActiveMessage,
                      //   ),
                      // SizedBox(height: isMobile ? 16.h : 24.h),
                      // ConfigurationInstructionsCard(
                      //   title: localizations.configurationInstructions,
                      //   instructions: [
                      //     localizations.companyMandatoryInstruction,
                      //     localizations.enableDisableLevelsInstruction,
                      //     localizations.useArrowsInstruction,
                      //     localizations.orderDeterminesRelationshipsInstruction,
                      //     localizations.changesAffectComponentsInstruction,
                      //   ],
                      //   boldText: localizations.company,
                      // ),
                      // SizedBox(height: isMobile ? 16.h : 24.h),
                      // Enterprise dropdown (only for create/edit modes)
                      if (widget.mode != EnterpriseStructureDialogMode.view) ...[
                        Consumer(
                          builder: (context, ref, child) {
                            final enterprisesState = ref.watch(enterprisesProvider);
                            final editState = ref.watch(_editDialogProvider(_params));

                            // Use editState's selectedEnterpriseId, fallback to widget's enterpriseId
                            final preferredId = editState.selectedEnterpriseId ?? widget.enterpriseId;

                            // Validate that the selected ID exists in the enterprises list
                            // If not, set to null to avoid dropdown assertion error
                            final selectedId =
                                preferredId != null && enterprisesState.enterprises.any((e) => e.id == preferredId)
                                ? preferredId
                                : null;

                            return EnterpriseDropdown(
                              label: 'Enterprise',
                              isRequired: true,
                              selectedEnterpriseId: selectedId,
                              enterprises: enterprisesState.enterprises,
                              isLoading: enterprisesState.isLoading,
                              readOnly: widget.mode == EnterpriseStructureDialogMode.view,
                              onChanged: (enterpriseId) {
                                ref.read(_editDialogProvider(_params).notifier).updateSelectedEnterprise(enterpriseId);
                              },
                              errorText: enterprisesState.hasError ? enterprisesState.errorMessage : null,
                            );
                          },
                        ),
                        SizedBox(height: isMobile ? 12.h : 16.h),
                      ],
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
                      SizedBox(height: isMobile ? 12.h : 16.h),
                      // IS_ACTIVE toggle switch (only for create/edit modes)
                      if (widget.mode != EnterpriseStructureDialogMode.view) ...[
                        Consumer(
                          builder: (context, ref, child) {
                            final editState = ref.watch(_editDialogProvider(_params));
                            return Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: isMobile ? 12.w : 16.w,
                                vertical: isMobile ? 12.h : 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Active',
                                    style: TextStyle(
                                      fontSize: isMobile ? 13.sp : 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                                    ),
                                  ),
                                  Switch(
                                    value: editState.isActive,
                                    onChanged: (value) {
                                      ref.read(_editDialogProvider(_params).notifier).updateIsActive(value);
                                    },
                                    activeThumbColor: AppColors.primary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: isMobile ? 16.h : 24.h),
                      ],

                      // Only show loading/error in create mode (when dialogState is available)
                      if (widget.mode == EnterpriseStructureDialogMode.create &&
                          levels.isEmpty &&
                          dialogState != null &&
                          dialogState.isLoading)
                        ShimmerLoadingWidget(isMobile: isMobile)
                      else if (widget.mode == EnterpriseStructureDialogMode.create &&
                          levels.isEmpty &&
                          dialogState != null &&
                          dialogState.hasError)
                        Padding(
                          padding: EdgeInsetsDirectional.all(16.w),
                          child: Text(
                            dialogState.errorMessage ?? 'Failed to load structure levels',
                            style: TextStyle(fontSize: 13.sp, color: Colors.red),
                          ),
                        )
                      else if (levels.isEmpty && (dialogState == null || !dialogState.isLoading))
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
                          mode: widget.mode,
                          levels: levels,
                          state: editState,
                          dialogState: dialogState,
                          params: _params,
                          editDialogProvider: _editDialogProvider,
                        ),
                      SizedBox(height: 24.h),
                      HierarchyPreviewSection(levels: levels),

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
              DialogFooter(
                mode: widget.mode,
                editState: editState,
                structureId: widget.structureId,
                provider: widget.provider,
                saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
