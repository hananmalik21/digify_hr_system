import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: 540.w,
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 26.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context, localizations),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    label: localizations.levelName,
                    value: jobLevel.nameEn,
                  ),
                ),
                SizedBox(width: 12.h),
                Flexible(
                  child: _buildField(
                    label: localizations.code,
                    value: jobLevel.code,
                  ),
                ),
              ],
            ),

            SizedBox(height: 26.5.h),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: _buildField(
                label: localizations.description,
                value: jobLevel.description,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildField(
                  label: localizations.minimumGrade,
                  value: jobLevel.gradeRange.split('-').first.trim(),
                ),
                _buildField(
                  label: localizations.maximumGrade,
                  value: jobLevel.gradeRange.split('-').last.trim(),
                ),
                _buildField(
                  label: localizations.totalPositions,
                  value: '${jobLevel.totalPositions}',
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Divider(color: AppColors.cardBorder, thickness: 1),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  label: localizations.close,
                  backgroundColor: AppColors.inputBg,
                  foregroundColor: AppColors.textSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 12.w),
                _buildActionButton(
                  label: localizations.edit,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            localizations.jobLevelDetails,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(32.w, 32.h)),
          icon: Icon(Icons.close, size: 20.sp, color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 16 / 12,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.5.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 22 / 17,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      minWidth: 100.w,
      height: 40.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
        side: backgroundColor == Colors.white
            ? BorderSide(color: AppColors.cardBorder)
            : BorderSide.none,
      ),
      color: backgroundColor,
      textColor: foregroundColor,
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
