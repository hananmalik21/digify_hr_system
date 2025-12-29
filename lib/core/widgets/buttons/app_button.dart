import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';

enum AppButtonType { primary, secondary, outline, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final String? svgPath;
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.svgPath,
    this.width = 144,
    this.height = 40,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    double width = 144,
    double height = 40,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      icon: icon,
      svgPath: svgPath,
      width: width,
      height: height,
    );
  }

  factory AppButton.secondary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    double width = 144,
    double height = 40,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.secondary,
      icon: icon,
      svgPath: svgPath,
      width: width,
      height: height,
    );
  }

  factory AppButton.outline({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    double width = 144,
    double height = 40,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      icon: icon,
      svgPath: svgPath,
      width: width,
      height: height,
    );
  }

  factory AppButton.danger({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    double width = 144,
    double height = 40,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.danger,
      icon: icon,
      svgPath: svgPath,
      width: width,
      height: height,
    );
  }

  Color _getBackgroundColor() {
    if (isLoading || onPressed == null) {
      return _getBaseBackgroundColor().withValues(alpha: 0.6);
    }
    return _getBaseBackgroundColor();
  }

  Color _getBaseBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
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
    if (foregroundColor != null) return foregroundColor!;
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
      buttonChild = AppLoadingIndicator(
        type: LoadingType.threeBounce,
        color: _getTextColor(),
        size: 20.sp,
      );
    } else if (icon != null || svgPath != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, size: 18.sp, color: _getTextColor())
          else if (svgPath != null)
            DigifyAsset(
              assetPath: svgPath!,
              width: 18,
              height: 18,
              color: _getTextColor(),
            ),
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
        minimumSize: Size(width?.w ?? 0, height?.h ?? 0),
        fixedSize: (width != null && height != null)
            ? Size(width!.w, height!.h)
            : null,
      ),
      child: buttonChild,
    );

    return button;
  }
}
