import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/extensions/context_extensions.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset_button.dart';
import 'package:digify_hr_system/core/widgets/badges/code_badge.dart';
import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/data/config/job_levels_table_config.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_detail_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobLevelRow extends ConsumerWidget {
  final JobLevel level;

  const JobLevelRow({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (JobLevelsTableConfig.showLevelName)
            _buildDataCell(
              Text(
                level.nameEn,
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                overflow: TextOverflow.ellipsis,
              ),
              JobLevelsTableConfig.levelNameWidth.w,
            ),
          if (JobLevelsTableConfig.showCode)
            _buildDataCell(CodeBadge(code: level.code.toUpperCase()), JobLevelsTableConfig.codeWidth.w),
          if (JobLevelsTableConfig.showDescription)
            _buildDataCell(
              Text(
                level.description,
                style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.tableHeaderText),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              JobLevelsTableConfig.descriptionWidth.w,
            ),
          if (JobLevelsTableConfig.showGradeRange)
            _buildDataCell(
              Text(
                level.gradeRange,
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                overflow: TextOverflow.ellipsis,
              ),
              JobLevelsTableConfig.gradeRangeWidth.w,
            ),
          if (JobLevelsTableConfig.showTotalPositions)
            _buildDataCell(
              Text(
                '${level.totalPositions}',
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
                overflow: TextOverflow.ellipsis,
              ),
              JobLevelsTableConfig.totalPositionsWidth.w,
            ),
          if (JobLevelsTableConfig.showActions)
            _buildDataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 8.w,
                children: [
                  DigifyAssetButton(
                    assetPath: Assets.icons.blueEyeIcon.path,
                    onTap: () => JobLevelDetailDialog.show(context, level),
                  ),
                  DigifyAssetButton(
                    assetPath: Assets.icons.editIcon.path,
                    onTap: () {
                      JobLevelFormDialog.show(context, jobLevel: level, isEdit: true, onSave: (updated) {});
                    },
                  ),
                  DigifyAssetButton(
                    assetPath: Assets.icons.redDeleteIcon.path,
                    onTap: () async {
                      final localizations = AppLocalizations.of(context)!;
                      final confirmed = await DeleteConfirmationDialog.show(
                        context,
                        title: localizations.deleteJobLevel,
                        message: localizations.deleteJobLevelConfirmationMessage,
                        itemName: level.nameEn,
                      );

                      if (confirmed == true) {
                        try {
                          await ref.read(jobLevelNotifierProvider.notifier).deleteJobLevel(level.id);
                          if (context.mounted) {
                            ToastService.success(context, localizations.jobLevelDeletedSuccessfully);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ToastService.error(context, localizations.errorDeletingJobLevel);
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
              JobLevelsTableConfig.actionsWidth.w,
            ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
