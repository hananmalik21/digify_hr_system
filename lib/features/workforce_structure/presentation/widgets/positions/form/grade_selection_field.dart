import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/grade_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const GradeSelectionField({
    super.key,
    required this.label,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(positionFormNotifierProvider);
    final selectedGrade = formState.grade;
    final gradesState = ref.watch(gradeNotifierProvider);
    final isLoading = gradesState.isLoading;
    final error = gradesState.errorMessage;

    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: InkWell(
        onTap: () async {
          // Trigger initial loading if needed
          if (gradesState.items.isEmpty && !isLoading && error == null) {
            ref.read(gradeNotifierProvider.notifier).loadFirstPage();
          }

          final selected = await GradeSelectionDialog.show(
            context: context,
            selectedGrade: selectedGrade,
          );

          if (selected != null) {
            ref.read(positionFormNotifierProvider.notifier).setGrade(selected);
          }
        },
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: error != null ? AppColors.error : AppColors.borderGrey,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedGrade?.gradeLabel ?? 'Select Grade',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedGrade != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
