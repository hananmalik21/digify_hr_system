import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_pattern.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/work_schedules/dialogs/work_pattern_selection_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternSelectionField extends ConsumerWidget {
  final String label;
  final bool isRequired;
  final int enterpriseId;
  final WorkPattern? selectedWorkPattern;
  final ValueChanged<WorkPattern?> onChanged;

  const WorkPatternSelectionField({
    super.key,
    required this.label,
    this.isRequired = true,
    required this.enterpriseId,
    this.selectedWorkPattern,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final workPatternsState = ref.watch(workPatternsNotifierProvider(enterpriseId));
    final error = workPatternsState.errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deleteIconRed,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: () async {
            final selected = await WorkPatternSelectionDialog.show(
              context: context,
              enterpriseId: enterpriseId,
              selectedWorkPattern: selectedWorkPattern,
            );

            if (selected != null) {
              onChanged(selected);
            }
          },
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: error != null ? AppColors.error : AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedWorkPattern?.patternNameEn ?? 'Select Work Pattern',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedWorkPattern != null
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
      ],
    );
  }
}
