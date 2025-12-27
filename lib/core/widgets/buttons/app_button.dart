import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';

enum AppButtonType { primary, secondary, outline, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.width,
    this.height,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      icon: icon,
      width: width,
    );
  }

  factory AppButton.secondary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.secondary,
      icon: icon,
      width: width,
    );
  }

  factory AppButton.outline({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      icon: icon,
      width: width,
    );
  }

  factory AppButton.danger({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.danger,
      icon: icon,
      width: width,
    );
  }

  Color _getBackgroundColor() {
    if (isLoading || onPressed == null) {
      return _getBaseBackgroundColor().withValues(alpha: 0.6);
    }
    return _getBaseBackgroundColor();
  }

  Color _getBaseBackgroundColor() {
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.textSecondary;
      case AppButtonType.outline:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.error;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.outline:
        return AppColors.primary;
    }
  }

  BorderSide? _getBorder() {
    if (type == AppButtonType.outline) {
      return BorderSide(
        color: isLoading || onPressed == null
            ? AppColors.borderGrey
            : AppColors.primary,
        width: 1.5,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.symmetric(vertical: 14.h);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(10.r);
    final effectiveFontSize = fontSize ?? 14.sp;

    Widget buttonChild;

    if (isLoading) {
      buttonChild = SizedBox(
        height: 20.h,
        width: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18.sp, color: _getTextColor()),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
          ),
        ],
      );
    } else {
      buttonChild = Text(
        label,
        style: TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.w600,
          color: _getTextColor(),
        ),
      );
    }

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getTextColor(),
        disabledBackgroundColor: _getBackgroundColor(),
        disabledForegroundColor: _getTextColor(),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: effectiveBorderRadius,
          side: _getBorder() ?? BorderSide.none,
        ),
        padding: effectivePadding,
      ),
      child: buttonChild,
    );

    if (width != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
