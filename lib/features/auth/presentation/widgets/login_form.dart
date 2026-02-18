import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/form_validators.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_checkbox.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_sign_in_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final bool isLoading;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPasswordTap;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.isLoading,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    this.onForgotPasswordTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DigifyTextField(
            controller: usernameController,
            focusNode: usernameFocusNode,
            hintText: localizations.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            fillColor: AppColors.authInputFill,
            borderColor: AppColors.authInputBorder,
            prefixIcon: _buildFieldIcon(Assets.icons.auth.mail.path),
            onSubmitted: (_) => passwordFocusNode.requestFocus(),
            validator: (value) => FormValidators.combine(value, [
              (v) => FormValidators.required(v, errorMessage: localizations.fieldRequired),
              (v) => FormValidators.email(v, errorMessage: localizations.invalidEmail),
            ]),
          ),
          const Gap(18),
          DigifyTextField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            hintText: localizations.password,
            obscureText: true,
            textInputAction: TextInputAction.done,
            fillColor: AppColors.authInputFill,
            borderColor: AppColors.authInputBorder,
            prefixIcon: _buildFieldIcon(Assets.icons.auth.lock.path),
            onSubmitted: (_) => onLogin(),
            validator: (value) => FormValidators.combine(value, [
              (v) => FormValidators.required(v, errorMessage: localizations.fieldRequired),
              (v) => FormValidators.minLength(v, 6, errorMessage: localizations.passwordTooShort),
            ]),
          ),
          const Gap(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: LoginCheckbox(
                  value: rememberMe,
                  onChanged: (value) => onRememberMeChanged(value ?? false),
                  label: localizations.rememberMe,
                ),
              ),
              GestureDetector(
                onTap: onForgotPasswordTap,
                child: Text(
                  localizations.forgotPasswordTitle.toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.authLinkText,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          LoginSignInButton(
            label: localizations.signInBtn,
            isLoading: isLoading,
            onPressed: isLoading ? null : onLogin,
            suffixIcon: Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldIcon(String assetPath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DigifyAsset(assetPath: assetPath, width: 20.w, height: 20.h, color: AppColors.sidebarTextSecondary),
    );
  }
}
