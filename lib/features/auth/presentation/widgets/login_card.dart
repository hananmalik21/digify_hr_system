import 'dart:ui';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_form.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_social_button.dart';
import 'package:digify_hr_system/core/widgets/common/digify_divider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;

class LoginCard extends ConsumerWidget {
  final double maxWidth;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;

  const LoginCard({
    super.key,
    required this.maxWidth,
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
    final authState = ref.watch(authProvider);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(35.r),
                border: Border.all(
                  color: Colors
                      .transparent, // We use a custom painter or gradient border in a moment, but for now let's use a subtle gradient
                  width: 1,
                ),
                boxShadow: AppShadows.loginCardShadow,
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
              ),
              child: Stack(
                children: [
                  // Specular Highlight Top Edge
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.5),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: math.max(16.0, math.min(40.w, 40.0)),
                      vertical: math.max(16.0, math.min(40.h, 40.0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.authBadgeBg,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: AppColors.authBadgeBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                ),
                                Gap(8.w),
                                Text(
                                  localizations.userAuthentication.toUpperCase(),
                                  style: context.textTheme.headlineMedium?.copyWith(
                                    fontSize: 9.sp,
                                    color: AppColors.primary,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        Text(
                          localizations.welcomeBack,
                          style: context.textTheme.displaySmall?.copyWith(
                            fontSize: 26.sp,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(8),
                        Text(
                          localizations.enterCredentialsToAccess,
                          style: context.textTheme.labelMedium?.copyWith(color: AppColors.dashReports, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        Gap(21.h),
                        LoginForm(
                          formKey: formKey,
                          usernameController: usernameController,
                          passwordController: passwordController,
                          usernameFocusNode: usernameFocusNode,
                          passwordFocusNode: passwordFocusNode,
                          isLoading: authState.isLoading,
                          rememberMe: rememberMe,
                          onRememberMeChanged: onRememberMeChanged,
                          onLogin: onLogin,
                          onForgotPasswordTap: onForgotPasswordTap,
                        ),
                        Gap(53.h),
                        Row(
                          children: [
                            const Expanded(child: DigifyDivider(color: AppColors.borderGrey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                localizations.orSignInWith,
                                style: context.textTheme.labelLarge?.copyWith(
                                  fontSize: 9.sp,
                                  color: AppColors.sidebarTextSecondary,
                                  letterSpacing: 3.5,
                                ),
                              ),
                            ),
                            const Expanded(child: DigifyDivider(color: AppColors.borderGrey)),
                          ],
                        ),
                        Gap(17.h),
                        Row(
                          children: [
                            Expanded(child: LoginSocialButton(iconPath: Assets.icons.auth.fingerprint.path)),
                            const Gap(14),
                            Expanded(child: LoginSocialButton(iconPath: Assets.icons.auth.window.path)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
