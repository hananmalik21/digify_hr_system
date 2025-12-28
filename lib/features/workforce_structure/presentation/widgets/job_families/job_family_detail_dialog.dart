import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_level.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_delete_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobFamilyDetailDialog extends ConsumerWidget {
  final JobFamily jobFamily;
  final List<JobLevel> jobLevels;

  const JobFamilyDetailDialog({
    super.key,
    required this.jobFamily,
    required this.jobLevels,
  });

  static Future<void> show(
    BuildContext context, {
    required JobFamily jobFamily,
    required List<JobLevel> jobLevels,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) =>
          JobFamilyDetailDialog(jobFamily: jobFamily, jobLevels: jobLevels),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final totalPositions = jobFamily.totalPositions.toString();
    final filledPositions = jobFamily.filledPositions.toString();
    final fillRate = '${jobFamily.fillRate.toStringAsFixed(0)}%';
    final deleteState = ref.watch(jobFamilyDeleteStateProvider);
    final isDeleting = deleteState.deletingId == jobFamily.id;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: 540.w,
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 26.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, localizations),
            SizedBox(height: 12.h),
            Text(
              jobFamily.nameArabic,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              localizations.basicInformation,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    jobFamily.description,
                    style: TextStyle(
                      fontSize: 15.4.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 22 / 15.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              localizations.positionStatistics,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _buildStatBlock(
                  label: localizations.totalPositions,
                  value: totalPositions,
                  backgroundColor: const Color(0xFFE8F0FE),
                  valueColor: AppColors.primary,
                ),
                SizedBox(width: 8.w),
                _buildStatBlock(
                  label: localizations.filledPositions,
                  value: filledPositions,
                  backgroundColor: const Color(0xFFEAF8F1),
                  valueColor: AppColors.greenButton,
                ),
                SizedBox(width: 8.w),
                _buildStatBlock(
                  label: localizations.fillRate,
                  value: fillRate,
                  backgroundColor: const Color(0xFFF4EBFF),
                  valueColor: const Color(0xFF6D2AE6),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Divider(color: AppColors.cardBorder, thickness: 1),
            SizedBox(height: 20.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    label: localizations.close,
                    backgroundColor: AppColors.inputBg,
                    foregroundColor: AppColors.textSecondary,
                    onPressed: isDeleting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 12.w),
                  _buildDeleteButton(
                    context: context,
                    ref: ref,
                    localizations: localizations,
                    isDeleting: isDeleting,
                  ),
                  SizedBox(width: 12.w),
                  _buildActionButton(
                    label: localizations.edit,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    onPressed: isDeleting
                        ? null
                        : () {
                            JobFamilyFormDialog.show(
                              context,
                              jobFamily: jobFamily,
                              isEdit: true,
                              onSave: (updated) {},
                            );
                          },
                  ),
                ],
              ),
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
            localizations.jobFamilyDetails,
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

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FB),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  Widget _buildStatBlock({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color valueColor,
  }) {
    return Expanded(
      child: Container(
        height: 88.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.6),
        elevation: 0,
        fixedSize: Size(100.w, 40.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: backgroundColor == Colors.white
              ? BorderSide(color: AppColors.cardBorder)
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDeleteButton({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required bool isDeleting,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.error.withValues(alpha: 0.6),
        elevation: 0,
        fixedSize: Size(100.w, 40.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      onPressed: isDeleting ? null : () => _handleDelete(context, ref),
      child: isDeleting
          ? SizedBox(
              height: 16.h,
              width: 16.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              localizations.delete,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(jobFamilyNotifierProvider.notifier)
          .deleteJobFamily(
            ref,
            ref.read(deleteJobFamilyUseCaseProvider),
            id: jobFamily.id,
          );

      if (context.mounted) {
        Navigator.of(context).pop(); // Close detail dialog
        ToastService.success(
          context,
          'Job family deleted successfully',
          title: 'Deleted',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(
          context,
          'Failed to delete job family',
          title: 'Error',
        );
      }
    }
  }
}
