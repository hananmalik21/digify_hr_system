import 'package:digify_hr_system/core/config/app_config.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/navigation/sidebar/sidebar_provider.dart';
import 'package:digify_hr_system/core/router/app_routes.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_animated_background.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_header.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_layout_handler.dart';
import 'package:flutter/foundation.dart';
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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(loginFormStateProvider.notifier).allowPrefillAgain();
    });
    if (kDebugMode) {
      _usernameController.text = AppConfig.debugUsername;
      _passwordController.text = AppConfig.debugPassword;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _usernameController.text.trim();
    final rememberMe = ref.read(loginFormStateProvider).rememberMe;

    await ref.read(authProvider.notifier).login(email, _passwordController.text.trim(), rememberMe: rememberMe);
  }

  void _showForgotPasswordDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.forgotPasswordTitle),
        content: Text(localizations.forgotPasswordDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormStateProvider);

    ref.listen<LoginFormState>(loginFormStateProvider, (prev, next) {
      if (!next.initialLoadDone || next.savedEmailConsumed) return;
      final email = ref.read(loginFormStateProvider.notifier).consumeSavedEmailForPrefill();
      if (email != null && email.isNotEmpty && (kReleaseMode || _usernameController.text.isEmpty)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _usernameController.text = email;
        });
      }
    });

    ref.listen<AuthState>(authProvider, (prev, next) {
      final feedback = next.pendingLoginFeedback;
      if (feedback != null) {
        ref.read(authProvider.notifier).clearPendingLoginFeedback();
        final localizations = AppLocalizations.of(context)!;
        if (feedback.success) {
          ToastService.success(context, localizations.loginSuccess);
          ref.read(sidebarProvider.notifier).collapse();
          context.go(AppRoutes.dashboard);
        } else {
          final message = switch (feedback.errorCode) {
            'network_error' => localizations.connectionError,
            _ => localizations.invalidCredentials,
          };
          ToastService.error(context, message, title: localizations.loginFailed);
        }
        return;
      }
      if (next.isAuthenticated && !next.isRestoring) {
        ref.read(sidebarProvider.notifier).collapse();
        context.go(AppRoutes.dashboard);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: ScreenUtil().screenHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.authBgEnd,
              gradient: RadialGradient(
                center: Alignment(-0.4, -0.4),
                radius: 1.2,
                colors: [AppColors.authBgStart, AppColors.authBgEnd],
                stops: [0.0, 1.0],
              ),
            ),
            child: Stack(
              children: [
                const LoginAnimatedBackground(),
                const LoginHeader(),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return LoginLayoutHandler(
                        constraints: constraints,
                        formKey: _formKey,
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        usernameFocusNode: _usernameFocusNode,
                        passwordFocusNode: _passwordFocusNode,
                        rememberMe: formState.rememberMe,
                        onRememberMeChanged: (value) => ref.read(loginFormStateProvider.notifier).setRememberMe(value),
                        onLogin: _handleLogin,
                        onForgotPasswordTap: _showForgotPasswordDialog,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
