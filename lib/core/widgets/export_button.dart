import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

/// Reusable Export button widget
/// Used across workforce and enterprise structure features
/// 
/// DEPRECATED: Use CustomButton directly instead
/// Example: CustomButton(
///   label: localizations.export,
///   svgIcon: 'assets/icons/download_icon.svg',
///   onPressed: () {},
///   backgroundColor: const Color(0xFF4A5565),
///   foregroundColor: Colors.white,
/// )
@Deprecated('Use CustomButton instead. This widget wraps CustomButton for backward compatibility.')
class ExportButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? customLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const ExportButton({
    super.key,
    required this.onTap,
    this.customLabel,
    this.backgroundColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return CustomButton(
      label: customLabel ?? localizations.export,
      svgIcon: 'assets/icons/download_icon.svg',
      onPressed: onTap,
      backgroundColor: backgroundColor ?? const Color(0xFF4A5565),
      foregroundColor: textColor ?? Colors.white,
      iconSize: iconSize,
      fontSize: fontSize,
      padding: padding,
    );
  }
}



