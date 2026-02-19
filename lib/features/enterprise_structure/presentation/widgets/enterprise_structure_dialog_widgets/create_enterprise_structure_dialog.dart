import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'create_form_body.dart';
import 'enterprise_structure_dialog_actions.dart';
import 'enterprise_structure_dialog_providers.dart';

class CreateEnterpriseStructureDialog extends ConsumerStatefulWidget {
  final int? enterpriseId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const CreateEnterpriseStructureDialog({super.key, this.enterpriseId, required this.provider});

  static Future<void> show(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
    int? enterpriseId,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ProviderScope(
        child: CreateEnterpriseStructureDialog(provider: provider, enterpriseId: enterpriseId),
      ),
    );
  }

  @override
  ConsumerState<CreateEnterpriseStructureDialog> createState() => _CreateEnterpriseStructureDialogState();
}

class _CreateEnterpriseStructureDialogState extends ConsumerState<CreateEnterpriseStructureDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final EditDialogParams _params;
  late final String _dialogId;
  bool _syncedApiToEditOnce = false;
  ProviderSubscription<EnterpriseStructureDialogState>? _apiSub;

  @override
  void initState() {
    super.initState();
    _dialogId = '${DateTime.now().millisecondsSinceEpoch}_${widget.hashCode}';
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _params = EditDialogParams(
      structureName: '',
      description: '',
      initialLevels: const [],
      selectedEnterpriseId: widget.enterpriseId,
      isActive: true,
    );
    if (widget.enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(editEnterpriseStructureDialogProvider(_params).notifier).updateSelectedEnterprise(widget.enterpriseId);
      });
    }
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
      final editState = ref.read(editEnterpriseStructureDialogProvider(_params));
      if (editState.levels.isNotEmpty) return;
      _syncedApiToEditOnce = true;
      ref.read(editEnterpriseStructureDialogProvider(_params).notifier).setLevels(apiLevels);
    });
  }

  @override
  void dispose() {
    _apiSub?.close();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final dialogState = ref.watch(enterpriseStructureDialogProvider(_dialogId));
    final editState = ref.watch(editEnterpriseStructureDialogProvider(_params));
    final levels = editState.levels;

    return AppDialog(
      title: localizations.createEnterpriseStructureConfiguration,
      subtitle: localizations.defineOrganizationalHierarchy,
      icon: DigifyAsset(
        assetPath: 'assets/icons/create_enterprise_icon.svg',
        width: 20,
        height: 20,
        color: AppColors.buttonTextLight,
      ),
      width: 900.w,
      onClose: () => context.pop(),
      content: CreateFormBody(
        levels: levels,
        editState: editState,
        dialogState: dialogState,
        params: _params,
        enterpriseId: widget.enterpriseId,
        nameController: _nameController,
        descriptionController: _descriptionController,
        localizations: localizations,
      ),
      actions: [EnterpriseStructureDialogActions(editState: editState, structureId: null, provider: widget.provider)],
    );
  }
}
