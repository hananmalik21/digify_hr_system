import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/grade.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    // TODO: Implement edit functionality
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletingGradeId = ref.watch(gradeNotifierProvider).deletingGradeId;
    final isDeleting = deletingGradeId == grade.id;

    return Row(
      children: [
        GestureDetector(
          onTap: isDeleting ? null : () => _handleEdit(context),
          child: SvgIconWidget(
            assetPath: Assets.icons.editIcon.path,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        if (isDeleting)
          SizedBox(
            width: 20.sp,
            height: 20.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
            ),
          )
        else
          GestureDetector(
            onTap: () async {
              final confirmed = await DeleteConfirmationDialog.show(
                context,
                title: 'Delete Grade',
                message:
                    'Are you sure you want to delete ${grade.gradeLabel}? This action cannot be undone.',
              );
              if (confirmed == true && context.mounted) {
                await _handleDelete(context, ref);
              }
            },
            child: SvgIconWidget(
              assetPath: Assets.icons.redDeleteIcon.path,
              size: 20.sp,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }
}
