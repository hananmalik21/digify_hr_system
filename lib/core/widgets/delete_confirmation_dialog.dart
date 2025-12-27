import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable delete confirmation dialog
/// 
/// Usage:
/// ```dart
/// final confirmed = await DeleteConfirmationDialog.show(
///   context,
///   title: 'Delete Company',
///   message: 'Are you sure you want to delete this company?',
///   itemName: 'Acme Corporation',
/// );
/// if (confirmed == true) {
///   // Perform delete action
/// }
/// ```
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.itemName,
    required this.onConfirm,
    this.onCancel,
    this.isLoading = false,
  });

  /// Shows the delete confirmation dialog
  /// 
  /// Returns `true` if user confirmed, `false` if cancelled, `null` if dismissed
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
    String? confirmText,
    String? cancelText,
  }) {
    final localizations = AppLocalizations.of(context);
    
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => _DeleteConfirmationDialogContent(
        title: title,
        message: message,
        itemName: itemName,
        confirmText: confirmText ?? localizations?.delete ?? 'Delete',
        cancelText: cancelText ?? localizations?.cancel ?? 'Cancel',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return _DeleteConfirmationDialogContent(
      title: title,
      message: message,
      itemName: itemName,
      confirmText: localizations?.delete ?? 'Delete',
      cancelText: localizations?.cancel ?? 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel,
      isLoading: isLoading,
    );
  }
}

class _DeleteConfirmationDialogContent extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;

  const _DeleteConfirmationDialogContent({
    required this.title,
    required this.message,
    this.itemName,
    required this.confirmText,
    required this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isLoading = false,
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
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsetsDirectional.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.error.withValues(alpha: 0.1),
                    AppColors.error.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.errorBg,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        height: 28 / 20,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: SvgIconWidget(
                        assetPath: 'assets/icons/close_dialog_icon.svg',
                        size: 20.sp,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
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
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                      height: 24 / 15.3,
                      letterSpacing: 0,
                    ),
                  ),
                  if (itemName != null) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsetsDirectional.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardBackgroundGreyDark
                            : AppColors.grayBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.cardBorderDark
                              : AppColors.cardBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              itemName!,
                              style: TextStyle(
                                fontSize: 15.3.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                                height: 24 / 15.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Footer
            Container(
              padding: EdgeInsetsDirectional.only(
                start: 24.w,
                end: 24.w,
                top: 20.h,
                bottom: 24.h,
              ),
              decoration: BoxDecoration(
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
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop(false);
                            onCancel?.call();
                          },
                    style: TextButton.styleFrom(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.cardBorderDark
                              : const Color(0xFFD1D5DC),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontSize: 15.3.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : const Color(0xFF364153),
                        height: 24 / 15.3,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : (onConfirm ?? () => Navigator.of(context).pop(true)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.error.withValues(alpha: 0.6),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgIconWidget(
                                assetPath: 'assets/icons/delete_icon_red.svg',
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                confirmText,
                                style: TextStyle(
                                  fontSize: 15.3.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 24 / 15.3,
                                ),
                              ),
                            ],
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
