import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/widgets/assets/svg_icon_widget.dart';

/// Universal CustomButton Widget
/// This is the ONLY button widget that should be used across the entire app.
/// It supports all button variants: primary, secondary, text, outlined, icon buttons, etc.
///
/// Usage Examples:
/// - Primary: CustomButton(label: 'Save', onPressed: () {})
/// - Secondary: CustomButton(label: 'Cancel', variant: ButtonVariant.secondary, onPressed: () {})
/// - With Icon: CustomButton(label: 'Add', icon: Icons.add, onPressed: () {})
/// - Icon Only: CustomButton(icon: Icons.edit, variant: ButtonVariant.icon, onPressed: () {})
/// - Loading: CustomButton(label: 'Submit', isLoading: true, onPressed: () {})
/// - Disabled: CustomButton(label: 'Submit', onPressed: null)
/// - With SVG: CustomButton(label: 'Import', svgIcon: 'assets/icons/upload.svg', onPressed: () {})
class CustomButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final String? svgIcon;
  final bool isLoading;
  final bool isExpanded;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? elevation;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final bool showShadow;
  final IconPosition iconPosition;

  const CustomButton({
    super.key,
    this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.svgIcon,
    this.isLoading = false,
    this.isExpanded = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconSize,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.height,
    this.width,
    this.fontWeight,
    this.showShadow = false,
    this.iconPosition = IconPosition.left,
  }) : assert(
         label != null || icon != null || svgIcon != null,
         'CustomButton must have either label, icon, or svgIcon',
       );

  /// Factory for primary action buttons
  factory CustomButton.primary({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
    );
  }

  /// Factory for secondary action buttons
  factory CustomButton.secondary({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
    );
  }

  /// Factory for outlined buttons
  factory CustomButton.outlined({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.outlined,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
    );
  }

  /// Factory for text-only buttons
  factory CustomButton.text({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.text,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
    );
  }

  /// Factory for icon-only buttons
  factory CustomButton.icon({
    required IconData? icon,
    String? svgIcon,
    required VoidCallback? onPressed,
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.medium,
    double? iconSize,
  }) {
    return CustomButton(
      onPressed: onPressed,
      variant: variant,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      iconSize: iconSize,
    );
  }

  /// Factory for danger/destructive action buttons
  factory CustomButton.danger({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.danger,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
    );
  }

  /// Factory for success/confirmation action buttons
  factory CustomButton.success({
    required String label,
    required VoidCallback? onPressed,
    IconData? icon,
    String? svgIcon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      variant: ButtonVariant.success,
      size: size,
      icon: icon,
      svgIcon: svgIcon,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null && !isLoading;

    // Get variant-specific colors
    final colors = _getButtonColors(isDark, isDisabled);

    // Get size-specific dimensions
    final dimensions = _getButtonDimensions();

    // Build the button content
    Widget content = _buildButtonContent(colors, dimensions);

    // Wrap with Material for ink effects
    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading || isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(
          borderRadius ?? dimensions.borderRadius,
        ),
        child: Container(
          height: height ?? dimensions.height,
          width: width ?? (isExpanded ? double.infinity : null),
          padding: padding ?? dimensions.padding,
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(
              borderRadius ?? dimensions.borderRadius,
            ),
            border: colors.borderColor != null
                ? Border.all(color: colors.borderColor!)
                : null,
            boxShadow: showShadow && !isDisabled
                ? [
                    BoxShadow(
                      color: colors.backgroundColor.withValues(alpha: 0.35),
                      blurRadius: 12.r,
                      offset: Offset(0, 6.h),
                    ),
                  ]
                : null,
          ),
          child: content,
        ),
      ),
    );

    return button;
  }

  Widget _buildButtonContent(
    _ButtonColors colors,
    _ButtonDimensions dimensions,
  ) {
    // Show loading indicator
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: dimensions.iconSize,
          height: dimensions.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(colors.foregroundColor),
          ),
        ),
      );
    }

    // Icon-only button
    if (label == null && (icon != null || svgIcon != null)) {
      return Center(child: _buildIcon(colors, dimensions));
    }

    // Button with label (and optional icon)
    List<Widget> children = [];

    // Add icon before label
    if (iconPosition == IconPosition.left &&
        (icon != null || svgIcon != null)) {
      children.add(_buildIcon(colors, dimensions));
      if (label != null) children.add(SizedBox(width: 8.w));
    }

    // Add label
    if (label != null) {
      children.add(
        Flexible(
          child: Text(
            label!,
            style: TextStyle(
              fontSize: fontSize ?? dimensions.fontSize,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: colors.foregroundColor,
              height: 24 / (fontSize ?? dimensions.fontSize),
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
    }

    // Add icon after label
    if (iconPosition == IconPosition.right &&
        (icon != null || svgIcon != null)) {
      if (label != null) children.add(SizedBox(width: 8.w));
      children.add(_buildIcon(colors, dimensions));
    }

    return Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildIcon(_ButtonColors colors, _ButtonDimensions dimensions) {
    final effectiveIconSize = iconSize ?? dimensions.iconSize;

    if (svgIcon != null) {
      return SvgIconWidget(
        assetPath: svgIcon!,
        size: effectiveIconSize,
        color: colors.foregroundColor,
      );
    }

    if (icon != null) {
      return Icon(icon, size: effectiveIconSize, color: colors.foregroundColor);
    }

    return const SizedBox.shrink();
  }

  _ButtonColors _getButtonColors(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return _ButtonColors(
        backgroundColor: isDark
            ? AppColors.grayBgDark.withValues(alpha: 0.3)
            : AppColors.grayBg.withValues(alpha: 0.5),
        foregroundColor: isDark ? AppColors.textMutedDark : AppColors.textMuted,
        borderColor: variant == ButtonVariant.outlined
            ? (isDark ? AppColors.borderGreyDark : AppColors.borderGrey)
            : null,
      );
    }

    // Custom colors override
    if (backgroundColor != null || foregroundColor != null) {
      return _ButtonColors(
        backgroundColor:
            backgroundColor ??
            (variant == ButtonVariant.text || variant == ButtonVariant.outlined
                ? Colors.transparent
                : AppColors.primary),
        foregroundColor: foregroundColor ?? Colors.white,
        borderColor:
            borderColor ??
            (variant == ButtonVariant.outlined
                ? (foregroundColor ?? AppColors.primary)
                : null),
      );
    }

    // Variant-specific colors
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        );

      case ButtonVariant.secondary:
        return _ButtonColors(
          backgroundColor: isDark
              ? AppColors.cardBackgroundDark
              : AppColors.cardBackgroundGrey,
          foregroundColor: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textSecondary,
        );

      case ButtonVariant.outlined:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark
              ? AppColors.textPrimaryDark
              : AppColors.primary,
          borderColor: isDark ? AppColors.borderGreyDark : AppColors.primary,
        );

      case ButtonVariant.text:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark
              ? AppColors.textPrimaryDark
              : AppColors.primary,
        );

      case ButtonVariant.danger:
        return _ButtonColors(
          backgroundColor: AppColors.redButton,
          foregroundColor: Colors.white,
        );

      case ButtonVariant.success:
        return _ButtonColors(
          backgroundColor: AppColors.greenButton,
          foregroundColor: Colors.white,
        );

      case ButtonVariant.icon:
        return _ButtonColors(
          backgroundColor: isDark
              ? AppColors.cardBackgroundDark
              : AppColors.cardBackground,
          foregroundColor: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimary,
          borderColor: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
        );

      case ButtonVariant.gradient:
        // For gradient buttons, backgroundColor will be the gradient color
        return _ButtonColors(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: Colors.white,
        );
    }
  }

  _ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case ButtonSize.small:
        return _ButtonDimensions(
          height: 32.h,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          fontSize: 13.sp,
          iconSize: 16.sp,
          borderRadius: 8.r,
        );

      case ButtonSize.medium:
        return _ButtonDimensions(
          height: 40.h,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          fontSize: 15.sp,
          iconSize: 20.sp,
          borderRadius: 10.r,
        );

      case ButtonSize.large:
        return _ButtonDimensions(
          height: 48.h,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
          fontSize: 16.sp,
          iconSize: 24.sp,
          borderRadius: 12.r,
        );
    }
  }
}

// Button variant types
enum ButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  danger,
  success,
  icon,
  gradient,
}

// Button size types
enum ButtonSize { small, medium, large }

// Icon position
enum IconPosition { left, right }

// Internal helper classes
class _ButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  _ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });
}

class _ButtonDimensions {
  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;

  _ButtonDimensions({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
  });
}
