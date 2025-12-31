import 'dart:math' as math;
import 'package:digify_hr_system/features/auth/presentation/widgets/login_branding_section.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_card.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_feature_cards.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_info_panel.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_system_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Handles responsive layout for login screen (stacked vs side-by-side)
class LoginLayoutHandler extends ConsumerWidget {
  final BoxConstraints constraints;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onLogin;

  const LoginLayoutHandler({
    super.key,
    required this.constraints,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;

    final isMobile = w < 600;
    final isTablet = w >= 600 && w < 1024;
    final isShortHeight = h < 700;

    if (isMobile) {
      return _buildStackedLayout(
        constraints: constraints,
        showInfoPanel: false,
        isShortHeight: isShortHeight,
      );
    }

    if (isTablet && w < 900) {
      return _buildStackedLayout(
        constraints: constraints,
        showInfoPanel: true,
        isShortHeight: isShortHeight,
      );
    }

    return _buildSideBySideLayout(constraints: constraints);
  }

  Widget _buildStackedLayout({
    required BoxConstraints constraints,
    required bool showInfoPanel,
    required bool isShortHeight,
  }) {
    final maxWidth = math.min(constraints.maxWidth, 560.0);
    final horizontal = math.max(16.0, (constraints.maxWidth - maxWidth) / 2);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(horizontal, 16.h, horizontal, 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: isShortHeight ? 12.h : 24.h),
            Center(
              child: LoginBrandingSection(center: true, maxWidth: maxWidth),
            ),
            SizedBox(height: 20.h),
            if (showInfoPanel) ...[
              LoginSystemDescription(center: true, maxWidth: maxWidth),
              SizedBox(height: 14.h),
              LoginFeatureCards(maxWidth: maxWidth),
              SizedBox(height: 20.h),
            ],
            LoginCard(
              maxWidth: maxWidth,
              formKey: formKey,
              usernameController: usernameController,
              passwordController: passwordController,
              usernameFocusNode: usernameFocusNode,
              passwordFocusNode: passwordFocusNode,
              onLogin: onLogin,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideBySideLayout({required BoxConstraints constraints}) {
    final pageMax = math.min(constraints.maxWidth, 1200.0);
    final paddingH = math.max(16.0, (constraints.maxWidth - pageMax) / 2);

    final cardWidth = math.min(
      520.0,
      math.max(420.0, constraints.maxWidth * 0.36),
    );
    final gap = math.min(48.0, math.max(20.0, constraints.maxWidth * 0.04));

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(paddingH, 16.h, paddingH, 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight - 40.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(child: LoginInfoPanel()),
              SizedBox(width: gap),
              SizedBox(
                width: cardWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: LoginCard(
                    maxWidth: cardWidth,
                    formKey: formKey,
                    usernameController: usernameController,
                    passwordController: passwordController,
                    usernameFocusNode: usernameFocusNode,
                    passwordFocusNode: passwordFocusNode,
                    onLogin: onLogin,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
