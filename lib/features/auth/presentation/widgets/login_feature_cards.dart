import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/features/auth/data/config/login_features_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Feature cards widget displaying key features of the system
class LoginFeatureCards extends StatelessWidget {
  final double? maxWidth;

  const LoginFeatureCards({super.key, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final features = LoginFeaturesConfig.getFeatures();

    final list = Column(
      children: features.map((feature) {
        final title = LoginFeaturesConfig.getLocalizedTitle(
          feature.titleKey,
          localizations,
        );
        final description = LoginFeaturesConfig.getLocalizedDescription(
          feature.descriptionKey,
          localizations,
        );

        return Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: feature.iconBackgroundColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: DigifyAsset(
                        assetPath: feature.iconPath,
                        width: 22,
                        height: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 15.5.sp.clamp(13.5, 17.5),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12.8.sp.clamp(11.5, 14.0),
                              fontWeight: FontWeight.normal,
                              color: AppColors.jobRoleBg,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    return maxWidth == null
        ? list
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth!),
            child: list,
          );
  }
}
