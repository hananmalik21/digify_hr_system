import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_detail_dialog.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_levels/job_level_form_dialog.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:digify_hr_system/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          _buildDataCell(
            Text(
              level.nameEn,
              style: TextStyle(
                fontSize: 13.7.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.7,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            244.57.w,
          ),
          _buildDataCell(
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                level.code,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6E11B0),
                  height: 16 / 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            133.38.w,
          ),
          _buildDataCell(
            Text(
              level.description,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 20 / 13.6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            446.61.w,
          ),
          _buildDataCell(
            Text(
              level.gradeRange,
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            248.44.w,
          ),
          _buildDataCell(
            Text(
              '${level.totalPositions}',
              style: TextStyle(
                fontSize: 13.6.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 20 / 13.6,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            216.64.w,
          ),
          _buildDataCell(
            Row(
              children: [
                _buildActionIcon(
                  Assets.icons.blueEyeIcon.path,
                  onTap: () => JobLevelDetailDialog.show(context, level),
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  Assets.icons.editIcon.path,
                  onTap: () {
                    JobLevelFormDialog.show(
                      context,
                      jobLevel: level,
                      isEdit: true,
                      onSave: (updated) {},
                    );
                  },
                ),
                SizedBox(width: 8.w),
                _buildActionIcon(
                  Assets.icons.redDeleteIcon.path,
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
                        await ref
                            .read(jobLevelNotifierProvider.notifier)
                            .deleteJobLevel(level.id);
                        if (context.mounted) {
                          ToastService.success(
                            context,
                            localizations.jobLevelDeletedSuccessfully,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ToastService.error(
                            context,
                            localizations.errorDeletingJobLevel,
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
            170.w,
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 24.w,
        vertical: 16.h,
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  Widget _buildActionIcon(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SvgIconWidget(assetPath: assetPath, size: 16.sp),
    );
  }
}
