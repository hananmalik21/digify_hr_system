import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/positions/form/job_family_selection_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamilySelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;

  const JobFamilySelectionField({super.key, required this.label, this.isRequired = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(positionFormNotifierProvider);
    final selectedJobFamily = formState.jobFamily;
    final jobFamiliesState = ref.watch(jobFamilyNotifierProvider);
    final isLoading = jobFamiliesState.isLoading;
    final error = jobFamiliesState.errorMessage;

    return PositionLabeledField(
      label: label,
      isRequired: isRequired,
      child: InkWell(
        onTap: () async {
          if (jobFamiliesState.items.isEmpty && !isLoading && error == null) {
            ref.read(jobFamilyNotifierProvider.notifier).loadFirstPage();
          }

          final selected = await JobFamilySelectionDialog.show(context: context, selectedJobFamily: selectedJobFamily);

          if (selected != null) {
            ref.read(positionFormNotifierProvider.notifier).setJobFamily(selected);
          }
        },
        child: Container(
          height: 40.h,
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
                  selectedJobFamily?.nameEnglish ?? 'Select Job Family',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedJobFamily != null
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
