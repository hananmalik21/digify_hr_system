import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enterprise_structure_dialog_widgets/create_enterprise_structure_dialog.dart';
import 'enterprise_structure_dialog_widgets/edit_enterprise_structure_dialog.dart';
import 'enterprise_structure_dialog_widgets/view_enterprise_structure_dialog.dart';
export 'enterprise_structure_dialog_widgets/enterprise_structure_dialog_mode.dart';

class EnterpriseStructureDialog {
  EnterpriseStructureDialog._();

  static Future<void> showView(
    BuildContext context, {
    required String structureName,
    required String description,
    int? enterpriseId,
    List<HierarchyLevel>? initialLevels,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return ViewEnterpriseStructureDialog.show(
      context,
      structureName: structureName,
      description: description,
      enterpriseId: enterpriseId,
      initialLevels: initialLevels,
      provider: provider,
    );
  }

  static Future<void> showEdit(
    BuildContext context, {
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
    int? enterpriseId,
    String? structureId,
    bool? isActive,
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return EditEnterpriseStructureDialog.show(
      context,
      structureName: structureName,
      description: description,
      initialLevels: initialLevels,
      enterpriseId: enterpriseId,
      structureId: structureId,
      isActive: isActive,
      provider: provider,
    );
  }

  static Future<void> showCreate(
    BuildContext context, {
    required AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider,
  }) {
    return CreateEnterpriseStructureDialog.show(context, provider: provider);
  }
}
