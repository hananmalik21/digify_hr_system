import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.isAuthenticated) {
          context.go('/dashboard');
        } else if (authState.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.error!),
              backgroundColor: context.themeErrorBg,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: context.themeBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 24.w,
              vertical: 32.h,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      localizations.appTitle,
                      style: context.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      localizations.welcome,
                      style: context.bodyMedium.copyWith(
                        color: context.themeTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48.h),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: localizations.email,
                        hintText: localizations.emailHint,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.fieldRequired;
                        }
                        if (!value.contains('@')) {
                          return localizations.invalidEmail;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        labelText: localizations.password,
                        hintText: localizations.passwordHint,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.fieldRequired;
                        }
                        if (value.length < 6) {
                          return localizations.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          localizations.forgotPassword,
                          style: context.bodySmall.copyWith(
                            color: context.themeTextSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      child: authState.isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(localizations.signIn),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.dontHaveAccount,
                          style: context.bodyMedium.copyWith(
                            color: context.themeTextSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(localizations.signUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
