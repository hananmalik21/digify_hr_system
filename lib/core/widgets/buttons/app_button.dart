import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';

enum AppButtonType { primary, secondary, outline, danger }

/// A customizable button widget that supports various types (primary, secondary, outline, danger)
/// and integrates with the app's design system.
///
/// It uses [Material] and [InkWell] for touch ripples and precise sizing control.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final String? svgPath;
  final Color? svgAssetColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.svgPath,
    this.svgAssetColor,
    this.width,
    double? height,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
  }) : height = height ?? 40.h;

  factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? svgPath,
    Color? svgAssetColor,
    double? width,
    double? height,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      icon: icon,
      svgPath: svgPath,
      svgAssetColor: svgAssetColor,
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
    Color? svgAssetColor,
    double? width,
    double? height,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.secondary,
      icon: icon,
      svgPath: svgPath,
      svgAssetColor: svgAssetColor,
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
    Color? svgAssetColor,
    double? width,
    double? height,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      icon: icon,
      svgPath: svgPath,
      svgAssetColor: svgAssetColor,
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
    Color? svgAssetColor,
    double? width,
    double? height,
  }) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.danger,
      icon: icon,
      svgPath: svgPath,
      svgAssetColor: svgAssetColor,
      width: width,
      height: height,
    );
  }

  Color _getBackgroundColor() {
    if (isLoading || onPressed == null) {
      switch (type) {
        case AppButtonType.outline:
          return Colors.transparent;
        case AppButtonType.primary:
        case AppButtonType.secondary:
        case AppButtonType.danger:
          return _getBaseBackgroundColor().withValues(alpha: 0.5);
      }
    }
    return _getBaseBackgroundColor();
  }

  Color _getBaseBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.cardBackgroundGrey;
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
        return AppColors.blackTextColor;
    }
  }

  BorderSide? _getBorder() {
    if (type == AppButtonType.outline) {
      final color = isLoading || onPressed == null ? AppColors.borderGrey : AppColors.borderGrey;
      return BorderSide(color: color, width: 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height?.h ?? 40.h;
    final effectiveWidth = width?.w;

    final effectivePadding = padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(10.r);
    final effectiveFontSize = fontSize ?? 15.sp;

    final isDisabled = isLoading || onPressed == null;
    final bgColor = _getBackgroundColor();
    final contentColor = isDisabled
        ? (type == AppButtonType.outline ? AppColors.textMuted : Colors.white70)
        : _getTextColor();
    final borderProp = _getBorder();

    final List<Widget> children = [];
    if (icon != null) {
      children.add(Icon(icon, size: 20.sp, color: contentColor));
      children.add(SizedBox(width: 8.w));
    } else if (svgPath != null) {
      children.add(DigifyAsset(assetPath: svgPath!, width: 20, height: 20, color: svgAssetColor ?? contentColor));
      children.add(SizedBox(width: 8.w));
    }
    if (label.isNotEmpty) {
      children.add(
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.w400,
            color: contentColor,
            height: 1.0,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: effectiveWidth != null
          ? SizedBox(
              width: effectiveWidth,
              height: effectiveHeight,
              child: Ink(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: effectiveBorderRadius,
                  border: borderProp != null ? Border.fromBorderSide(borderProp) : null,
                ),
                child: InkWell(
                  onTap: isDisabled ? null : onPressed,
                  borderRadius: effectiveBorderRadius.resolve(TextDirection.ltr),
                  child: Container(
                    padding: effectivePadding,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: isLoading ? 0.0 : 1.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          ),
                        ),
                        if (isLoading) AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 20.sp),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Ink(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: effectiveBorderRadius,
                border: borderProp != null ? Border.fromBorderSide(borderProp) : null,
              ),
              child: InkWell(
                onTap: isDisabled ? null : onPressed,
                borderRadius: effectiveBorderRadius.resolve(TextDirection.ltr),
                child: Container(
                  padding: effectivePadding,
                  constraints: BoxConstraints(minHeight: effectiveHeight),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: isLoading
                        ? [AppLoadingIndicator(type: LoadingType.circle, color: contentColor, size: 20.sp)]
                        : children,
                  ),
                ),
              ),
            ),
    );
  }
}
