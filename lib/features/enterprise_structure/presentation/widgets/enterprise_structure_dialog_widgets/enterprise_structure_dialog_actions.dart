import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/buttons/custom_button.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'enterprise_structure_dialog_providers.dart';

class EnterpriseStructureDialogActions extends ConsumerWidget {
  final EditEnterpriseStructureState? editState;
  final String? structureId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> provider;

  const EnterpriseStructureDialogActions({
    super.key,
    required this.editState,
    this.structureId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveState = ref.watch(saveEnterpriseStructureDialogProvider);
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: saveState.isSaving ? null : () => context.pop(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
        Gap(16.w),
        CustomButton.icon(
          svgIcon: Assets.icons.saveConfigIcon.path,
          isLoading: saveState.isSaving,
          onPressed: saveState.isSaving
              ? null
              : () async {
                  final currentEditState = editState;
                  if (currentEditState == null) return;

                  if (currentEditState.selectedEnterpriseId == null) {
                    ToastService.error(context, 'Please select an enterprise');
                    return;
                  }
                  if (currentEditState.structureName.trim().isEmpty) {
                    ToastService.error(context, 'Structure name is required');
                    return;
                  }
                  if (currentEditState.levels.isEmpty) {
                    ToastService.error(context, 'At least one level is required');
                    return;
                  }

                  final saveNotifier = ref.read(saveEnterpriseStructureDialogProvider.notifier);
                  try {
                    final success = await saveNotifier.saveStructure(
                      structureName: currentEditState.structureName.trim(),
                      description: currentEditState.description.trim(),
                      levels: currentEditState.levels,
                      enterpriseId: currentEditState.selectedEnterpriseId,
                      isActive: currentEditState.isActive,
                      structureId: structureId,
                    );

                    if (!context.mounted) return;
                    if (success) {
                      ref.read(provider.notifier).refresh();
                      context.pop(true);
                      ToastService.success(context, 'Structure saved successfully');
                    }
                  } on AppException catch (e) {
                    if (!context.mounted) return;
                    ToastService.error(context, e.message);
                  } catch (e) {
                    if (!context.mounted) return;
                    ToastService.error(context, 'Failed to save structure: ${e.toString()}');
                  }
                },
          text: 'Save Configuration',
          icon: null,
        ),
      ],
    );
  }
}
