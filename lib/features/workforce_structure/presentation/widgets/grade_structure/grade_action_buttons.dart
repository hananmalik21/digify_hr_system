import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/grade_structure/update_grade_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeActionButtons extends ConsumerWidget {
  final Grade grade;

  const GradeActionButtons({super.key, required this.grade});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(gradeNotifierProvider.notifier).deleteGrade(grade.id);
      if (context.mounted) {
        ToastService.success(context, 'Grade deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Error deleting grade');
      }
    }
  }

  void _handleEdit(BuildContext context) {
    UpdateGradeDialog.show(context, grade: grade);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletingGradeId = ref.watch(gradeNotifierProvider).deletingGradeId;
    final isDeleting = deletingGradeId == grade.id;

    return Row(
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.editIcon.path,
          width: 16,
          height: 16,
          onTap: isDeleting ? null : () => _handleEdit(context),
        ),
        Gap(4.w),
        DigifyAssetButton(
          assetPath: Assets.icons.redDeleteIcon.path,
          width: 16,
          height: 16,
          color: AppColors.error,
          isLoading: isDeleting,
          onTap: () async {
            final confirmed = await AppConfirmationDialog.show(
              context,
              title: 'Delete Grade',
              message: 'Are you sure you want to delete this grade? This action cannot be undone.',
              itemName: grade.gradeLabel,
              confirmLabel: 'Delete',
              cancelLabel: 'Cancel',
              type: ConfirmationType.danger,
            );
            if (confirmed == true && context.mounted) {
              await _handleDelete(context, ref);
            }
          },
        ),
      ],
    );
  }
}
