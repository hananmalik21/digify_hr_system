import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable delete confirmation dialog
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.itemName,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => _DeleteConfirmationDialogContent(
        title: title,
        message: message,
        itemName: itemName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DeleteConfirmationDialogContent(
      title: title,
      message: message,
      itemName: itemName,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}

class _DeleteConfirmationDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const _DeleteConfirmationDialogContent({
    required this.title,
    required this.message,
    this.itemName,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsetsDirectional.all(24.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.errorBgDark
                          : AppColors.errorBg,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgIconWidget(
                      assetPath: 'assets/icons/delete_icon_red.svg',
                      size: 24.sp,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        height: 24 / 18,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    iconSize: 24.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsetsDirectional.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                      height: 20 / 14,
                      letterSpacing: 0,
                    ),
                  ),
                  if (itemName != null) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(12.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardBackgroundGreyDark
                            : AppColors.grayBg,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        itemName!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                          height: 20 / 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Footer
            Container(
              padding: EdgeInsetsDirectional.all(24.w),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark
                    : const Color(0xFFF9FAFB),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.cardBorderDark
                        : AppColors.cardBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15.3.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textSecondary,
                        height: 24 / 15.3,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 15.3.sp,
                        fontWeight: FontWeight.w400,
                        height: 24 / 15.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

