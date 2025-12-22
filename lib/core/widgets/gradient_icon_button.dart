import 'package:digify_hr_system/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Gradient/Colored Icon Button widget
/// 
/// DEPRECATED: Use CustomButton directly instead
/// Example: CustomButton(
///   label: 'Add New',
///   svgIcon: 'assets/icons/add_icon.svg',
///   onPressed: () {},
///   backgroundColor: AppColors.primary,
///   showShadow: true,
/// )
@Deprecated('Use CustomButton instead. This widget wraps CustomButton for backward compatibility.')
class GradientIconButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double? shadowOpacity;
  final EdgeInsets? padding;
  final double? iconSize;
  final double? fontSize;

  const GradientIconButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
    required this.backgroundColor,
    this.shadowOpacity,
    this.padding,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: label,
      svgIcon: iconPath,
      onPressed: onTap,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      showShadow: true,
      padding: padding,
      iconSize: iconSize,
      fontSize: fontSize,
    );
  }
}

