import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/models/job_family.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_delete_state.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';

class DeleteJobFamilyDialog extends ConsumerWidget {
  final JobFamily jobFamily;

  const DeleteJobFamilyDialog({super.key, required this.jobFamily});

  static Future<void> show(BuildContext context, {required JobFamily jobFamily}) {
    return showDialog(
      context: context,
      builder: (_) => DeleteJobFamilyDialog(jobFamily: jobFamily),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    try {
      // Loading state will show in THIS confirmation dialog
      await ref.deleteJobFamily(id: jobFamily.id);

      if (context.mounted) {
        context.pop();
        context.pop();
        ToastService.success(context, 'Job family deleted successfully', title: 'Deleted');
      }
    } catch (e) {
      if (context.mounted) {
        context.pop();
        ToastService.error(context, 'Failed to delete job family', title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(jobFamilyDeleteStateProvider);
    final isDeleting = deleteState.deletingId == jobFamily.id;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.error, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              'Delete Job Family',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this job family?',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobFamily.nameEnglish,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.errorText),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    jobFamily.code,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorText.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This action cannot be undone.',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.error),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: isDeleting ? null : () => _handleDelete(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.error.withValues(alpha: 0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
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
                    'Delete',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }
}
