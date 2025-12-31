import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// System description widget displaying the main description text
class LoginSystemDescription extends StatelessWidget {
  final bool center;
  final double? maxWidth;

  const LoginSystemDescription({super.key, this.center = false, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final text = Text(
      localizations.systemDescription,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 16.5.sp.clamp(14.0, 18.5),
        fontWeight: FontWeight.normal,
        color: AppColors.infoBg,
        height: 1.7,
      ),
    );

    final content = maxWidth == null
        ? text
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth!),
            child: text,
          );

    return content;
  }
}
