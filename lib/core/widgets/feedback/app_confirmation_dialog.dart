import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ConfirmationType { info, warning, danger, success }

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final ConfirmationType type;
  final bool isLoading;
  final IconData? icon;
  final String? svgPath;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.itemName,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.type = ConfirmationType.danger,
    this.isLoading = false,
    this.icon,
    this.svgPath,
  });

  factory AppConfirmationDialog.delete({
    Key? key,
    required String title,
    required String message,
    String? itemName,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isLoading = false,
  }) {
    return AppConfirmationDialog(
      key: key,
      title: title,
      message: message,
      itemName: itemName,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
      type: ConfirmationType.danger,
      isLoading: isLoading,
      svgPath: Assets.icons.deleteIconRed.path,
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    ConfirmationType type = ConfirmationType.danger,
    IconData? icon,
    String? svgPath,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => AppConfirmationDialog(
        title: title,
        message: message,
        itemName: itemName,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
        type: type,
        icon: icon,
        svgPath: svgPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = _getTypeColor();
    final bgColor = _getTypeBgColor(isDark);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Container(
          width: 0.85.sw,
          constraints: BoxConstraints(maxWidth: 340.w),
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 28.h),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Center(
                  child: svgPath != null
                      ? DigifyAsset(assetPath: svgPath!, width: 28.w, height: 28.w, color: color)
                      : Icon(icon ?? _getDefaultIcon(), color: color, size: 28.sp),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    if (itemName != null) ...[
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.grayBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : AppColors.grayBorder.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          itemName!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: cancelLabel,
                        type: AppButtonType.outline,
                        height: 42.h,
                        onPressed: isLoading ? null : (onCancel ?? () => Navigator.of(context).pop()),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppButton(
                        label: confirmLabel,
                        type: type == ConfirmationType.danger ? AppButtonType.danger : AppButtonType.primary,
                        height: 42.h,
                        isLoading: isLoading,
                        onPressed: onConfirm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case ConfirmationType.danger:
        return AppColors.error;
      case ConfirmationType.warning:
        return AppColors.warning;
      case ConfirmationType.success:
        return AppColors.success;
      case ConfirmationType.info:
        return AppColors.info;
    }
  }

  Color _getTypeBgColor(bool isDark) {
    if (isDark) {
      switch (type) {
        case ConfirmationType.danger:
          return AppColors.error.withValues(alpha: 0.15);
        case ConfirmationType.warning:
          return AppColors.warning.withValues(alpha: 0.15);
        case ConfirmationType.success:
          return AppColors.success.withValues(alpha: 0.15);
        case ConfirmationType.info:
          return AppColors.info.withValues(alpha: 0.15);
      }
    } else {
      switch (type) {
        case ConfirmationType.danger:
          return AppColors.errorBg;
        case ConfirmationType.warning:
          return AppColors.warningBg;
        case ConfirmationType.success:
          return AppColors.successBg;
        case ConfirmationType.info:
          return AppColors.infoBg;
      }
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case ConfirmationType.danger:
        return Icons.delete_outline_rounded;
      case ConfirmationType.warning:
        return Icons.warning_amber_rounded;
      case ConfirmationType.success:
        return Icons.check_circle_outline_rounded;
      case ConfirmationType.info:
        return Icons.info_outline_rounded;
    }
  }
}
