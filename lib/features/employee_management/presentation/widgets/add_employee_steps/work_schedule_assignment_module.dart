import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/work_schedule_selection_field.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleAssignmentModule extends StatelessWidget {
  const WorkScheduleAssignmentModule({
    super.key,
    required this.enterpriseId,
    this.selectedWorkSchedule,
    this.onWorkScheduleChanged,
  });

  final int? enterpriseId;
  final WorkSchedule? selectedWorkSchedule;
  final ValueChanged<WorkSchedule?>? onWorkScheduleChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.clockIcon.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.workScheduleAssignment,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          if (enterpriseId != null)
            WorkScheduleSelectionField(
              label: localizations.workSchedule,
              isRequired: false,
              enterpriseId: enterpriseId!,
              selectedWorkSchedule: selectedWorkSchedule,
              onChanged: onWorkScheduleChanged ?? (_) {},
            )
          else
            _WorkScheduleFieldPlaceholder(
              label: localizations.workSchedule,
              hint: localizations.hintSelectWorkSchedule,
            ),
        ],
      ),
    );
  }
}

class _WorkScheduleFieldPlaceholder extends StatelessWidget {
  const _WorkScheduleFieldPlaceholder({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
          ),
        ),
        Gap(6.h),
        Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.inputBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.searchIcon.path,
                width: 20,
                height: 20,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  hint,
                  style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary.withValues(alpha: 0.6)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DigifyAsset(
                assetPath: Assets.icons.workforce.chevronDown.path,
                color: AppColors.textSecondary,
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
