import 'package:digify_hr_system/features/auth/presentation/widgets/login_branding_section.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_feature_cards.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_system_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Info panel widget combining branding, description, and feature cards
class LoginInfoPanel extends StatelessWidget {
  const LoginInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LoginBrandingSection(center: false),
        SizedBox(height: 24.h),
        const LoginSystemDescription(center: false),
        SizedBox(height: 14.h),
        const LoginFeatureCards(),
      ],
    );
  }
}
