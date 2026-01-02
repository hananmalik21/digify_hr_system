import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_primary_button.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Login form widget containing username, password fields and submit button
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final bool isLoading;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.isLoading,
    required this.onLogin,
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
            labelText: localizations.username,
            hintText: localizations.usernameHint,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 12.w),
              child: DigifyAsset(
                assetPath: Assets.icons.emailCardIcon.path,
                width: 20,
                height: 20,
                color: AppColors.textPlaceholder,
              ),
            ),
            onSubmitted: (_) => passwordFocusNode.requestFocus(),
            validator: (value) => (value == null || value.isEmpty)
                ? localizations.fieldRequired
                : null,
          ),
          SizedBox(height: 18.h),
          DigifyTextField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            labelText: localizations.password,
            hintText: localizations.passwordHint,
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 12.w),
              child: DigifyAsset(
                assetPath: Assets.icons.lockIcon.path,
                width: 20,
                height: 20,
                color: AppColors.textPlaceholder,
              ),
            ),
            onSubmitted: (_) => onLogin(),
            validator: (value) => (value == null || value.isEmpty)
                ? localizations.fieldRequired
                : null,
          ),
          SizedBox(height: 18.h),
          LoginPrimaryButton(
            text: localizations.signIn,
            isLoading: isLoading,
            onTap: isLoading ? null : onLogin,
          ),
        ],
      ),
    );
  }
}
