import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'view_mode_content.dart';

class ViewEnterpriseStructureDialog extends StatelessWidget {
  final String structureName;
  final String description;
  final List<HierarchyLevel>? initialLevels;
  final int? enterpriseId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const ViewEnterpriseStructureDialog({
    super.key,
    required this.structureName,
    required this.description,
    this.initialLevels,
    this.enterpriseId,
    required this.provider,
  });

  static Future<void> show(
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
      builder: (context) => ViewEnterpriseStructureDialog(
        structureName: structureName,
        description: description,
        enterpriseId: enterpriseId,
        initialLevels: initialLevels,
        provider: provider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final levels = initialLevels ?? const <HierarchyLevel>[];
    final params = EditDialogParams(
      structureName: structureName,
      description: description,
      initialLevels: levels,
      selectedEnterpriseId: enterpriseId,
      isActive: true,
    );

    return AppDialog(
      title: localizations.viewEnterpriseStructureConfiguration,
      subtitle: localizations.reviewOrganizationalHierarchy,
      width: 900.w,
      onClose: () => context.pop(),
      content: ViewModeContent(
        localizations: localizations,
        levels: levels,
        structureName: structureName,
        description: description,
        params: params,
      ),
    );
  }
}
