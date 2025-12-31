import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Login card widget containing the login form
class LoginCard extends ConsumerWidget {
  final double maxWidth;
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onLogin;

  const LoginCard({
    super.key,
    required this.maxWidth,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    final innerPad = (maxWidth < 420 ? 20.0 : 28.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 50,
                offset: const Offset(0, 25),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(innerPad.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Text(
                      localizations.welcomeBack,
                      style: TextStyle(
                        fontSize: 26.sp.clamp(20.0, 30.0),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      localizations.signInToAccessDashboard,
                      style: TextStyle(
                        fontSize: 14.5.sp.clamp(12.5, 16.0),
                        fontWeight: FontWeight.normal,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                LoginForm(
                  formKey: formKey,
                  usernameController: usernameController,
                  passwordController: passwordController,
                  usernameFocusNode: usernameFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  isLoading: authState.isLoading,
                  onLogin: onLogin,
                ),
                SizedBox(height: 22.h),
                Text(
                  localizations.copyrightText,
                  style: TextStyle(
                    fontSize: 12.8.sp.clamp(11.0, 14.0),
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6A7282),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
