import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/svg_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable Add Position button widget
/// Used in workforce structure feature
class AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? customLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const AddButton({
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
    final effectiveBackgroundColor = backgroundColor ?? const Color(0xFF155DFC);
    final effectiveTextColor = textColor ?? Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: padding ??
              EdgeInsetsDirectional.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIconWidget(
                assetPath: 'assets/icons/add_division_icon.svg',
                size: iconSize ?? 20.sp,
                color: effectiveTextColor,
              ),
              SizedBox(width: 8.w),
              Text(
                customLabel ?? localizations.addPosition,
                style: TextStyle(
                  fontSize: fontSize ?? 15.sp,
                  fontWeight: FontWeight.w400,
                  color: effectiveTextColor,
                  height: 24 / 15,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



