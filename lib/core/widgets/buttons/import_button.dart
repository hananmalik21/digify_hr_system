import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class ImportButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? customLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const ImportButton({
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
      label: customLabel ?? localizations.import,
      svgIcon: 'assets/icons/bulk_upload_icon_figma.svg',
      onPressed: onTap,
      backgroundColor: backgroundColor ?? const Color(0xFFE7F2FF),
      foregroundColor: textColor ?? const Color(0xFF155DFC),
      iconSize: iconSize,
      fontSize: fontSize,
      padding: padding,
    );
  }
}
