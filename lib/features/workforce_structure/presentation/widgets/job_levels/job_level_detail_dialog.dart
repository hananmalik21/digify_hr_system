import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobLevelDetailDialog extends StatelessWidget {
  final JobLevel jobLevel;

  const JobLevelDetailDialog({super.key, required this.jobLevel});

  static Future<void> show(BuildContext context, JobLevel jobLevel) {
    return showDialog<void>(
      context: context,
      builder: (_) => JobLevelDetailDialog(jobLevel: jobLevel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AppDialog(
      title: localizations.jobLevelDetails,
      width: 540.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildField(context: context, label: localizations.levelName, value: jobLevel.nameEn),
              ),
              Gap(12.h),
              Flexible(
                child: _buildField(context: context, label: localizations.code, value: jobLevel.code),
              ),
            ],
          ),
          Gap(26.5.h),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: _buildField(
              context: context,
              label: localizations.description,
              value: jobLevel.description,
              valueStyle: context.textTheme.titleSmall?.copyWith(fontSize: 15.sp, color: AppColors.textPrimary),
            ),
          ),
          Gap(30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildField(
                context: context,
                label: localizations.minimumGrade,
                value: jobLevel.gradeRange.split('-').first.trim(),
              ),
              _buildField(
                context: context,
                label: localizations.maximumGrade,
                value: jobLevel.gradeRange.split('-').last.trim(),
              ),
              _buildField(context: context, label: localizations.totalPositions, value: '${jobLevel.totalPositions}'),
            ],
          ),
        ],
      ),
      actions: [
        AppButton(
          label: localizations.close,
          backgroundColor: AppColors.inputBg,
          foregroundColor: AppColors.textSecondary,
          onPressed: () => context.pop(),
          width: 100.w,
        ),
        Gap(12.w),
        AppButton.primary(
          label: localizations.edit,
          onPressed: () {
            JobLevelFormDialog.show(context, jobLevel: jobLevel, isEdit: true, onSave: (updated) {});
          },
          width: 100.w,
        ),
      ],
    );
  }

  Widget _buildField({
    required BuildContext context,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        Gap(4.h),
        Text(
          value,
          style:
              valueStyle ??
              context.textTheme.displayLarge?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
