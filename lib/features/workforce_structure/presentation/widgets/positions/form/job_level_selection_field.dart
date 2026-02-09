import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/job_level_selection_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/assets/digify_asset.dart';

class JobLevelSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const JobLevelSelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(positionFormNotifierProvider);
    final selectedJobLevel = formState.jobLevel;
    final jobLevelsState = ref.watch(jobLevelNotifierProvider);
    final isLoading = jobLevelsState.isLoading;
    final error = jobLevelsState.errorMessage;

    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: InkWell(
        onTap: () async {
          // Trigger initial loading if needed
          if (jobLevelsState.items.isEmpty && !isLoading && error == null) {
            ref.read(jobLevelNotifierProvider.notifier).loadFirstPage();
          }

          final selected = await JobLevelSelectionDialog.show(context: context, selectedJobLevel: selectedJobLevel);

          if (selected != null) {
            ref.read(positionFormNotifierProvider.notifier).setJobLevel(selected);
          }
        },
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: error != null ? AppColors.error : AppColors.borderGrey),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedJobLevel?.nameEn ?? 'Select Job Level',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedJobLevel != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DigifyAsset(
                assetPath: Assets.icons.workforce.chevronRight.path,
                color: AppColors.textSecondary,
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
