import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Branding section widget displaying logo, title, and subtitle
class LoginBrandingSection extends StatelessWidget {
  final bool center;
  final double? maxWidth;

  const LoginBrandingSection({super.key, this.center = false, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final titleSize = (center ? 30.sp : 34.5.sp).clamp(24.0, 36.0);
    final subSize = (center ? 14.sp : 16.9.sp).clamp(12.0, 18.0);

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: DigifyAsset(
                assetPath: Assets.icons.securityIcon.path,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.digifyHrTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.16,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.kuwaitLaborLawCompliant,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: subSize,
                  fontWeight: FontWeight.normal,
                  color: AppColors.jobRoleBg,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final content = maxWidth == null
        ? row
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth!),
            child: row,
          );

    return center ? Center(child: content) : content;
  }
}
