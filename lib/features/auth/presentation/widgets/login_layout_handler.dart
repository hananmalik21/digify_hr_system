import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/app_text_theme.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginLayoutHandler extends ConsumerWidget {
  final BoxConstraints constraints;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;

  const LoginLayoutHandler({
    super.key,
    required this.constraints,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final w = constraints.maxWidth;

    final isMobile = w < 600;

    return _buildCenteredLayout(constraints: constraints, isMobile: isMobile, localizations: localizations);
  }

  Widget _buildCenteredLayout({
    required BoxConstraints constraints,
    required bool isMobile,
    required AppLocalizations localizations,
  }) {
    final maxWidth = isMobile ? (constraints.maxWidth - 40.w).clamp(280.0, 460.0.w) : 460.0.w;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(isMobile ? 80.h : 40.h),
            LoginCard(
              maxWidth: maxWidth,
              formKey: formKey,
              usernameController: usernameController,
              passwordController: passwordController,
              usernameFocusNode: usernameFocusNode,
              passwordFocusNode: passwordFocusNode,
              rememberMe: rememberMe,
              onRememberMeChanged: onRememberMeChanged,
              onLogin: onLogin,
              onForgotPasswordTap: onForgotPasswordTap,
            ),
            Gap(9.h),
            _buildFooter(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations localizations) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.sidebarTextSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            const Gap(8),
            Text(
              localizations.endToEndEncrypted,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                fontSize: 8.sp,
                color: AppColors.sidebarTextSecondary,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        Gap(27.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.copyright_rounded, size: 12.sp, color: AppColors.sidebarTextSecondary.withValues(alpha: 0.8)),
            Gap(6.w),
            Text(
              localizations.copyrightInfo,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                fontSize: 10.sp,
                color: AppColors.sidebarTextSecondary.withValues(alpha: 0.8),
                letterSpacing: 4.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
