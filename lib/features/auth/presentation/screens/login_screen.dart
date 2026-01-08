import 'dart:developer';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:digify_hr_system/features/auth/presentation/widgets/login_layout_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    if (kDebugMode) {
      _usernameController.text = 'admin';
      _passwordController.text = 'Digify@@2025';
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

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes for navigation and error handling
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) return;

      final localizations = AppLocalizations.of(context)!;

      // Handle authentication success
      if (next.isAuthenticated && !next.isLoading) {
        context.go('/dashboard');
        return;
      }

      // Handle errors - show when error exists, not loading, and not authenticated
      // Only show if this is a new error (previous had no error or different error)
      if (!next.isAuthenticated &&
          !next.isLoading &&
          next.error != null &&
          next.error!.isNotEmpty) {
        // Check if this is a new error (wasn't present before)
        final isNewError =
            previous == null ||
            previous.error == null ||
            previous.error != next.error;

        if (isNewError) {
          log("Showing error toast: ${next.error}");
          // Show toast directly - ToastService will handle overlay access
          if (mounted) {
            ToastService.success(context, next.error!);
            log("ToastService.error called with context: ${context.runtimeType}");
          }
        }
      }
    });

    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, Color(0xFF4F39F6), Color(0xFF8200DB)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return LoginLayoutHandler(
                constraints: constraints,
                formKey: _formKey,
                usernameController: _usernameController,
                passwordController: _passwordController,
                usernameFocusNode: _usernameFocusNode,
                passwordFocusNode: _passwordFocusNode,
                onLogin: _handleLogin,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    log("Starting login...");
    try {
      await ref
          .read(authProvider.notifier)
          .login(_usernameController.text.trim(), _passwordController.text);
      log("Login completed");
    } catch (e) {
      log("Login error: $e");
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ToastService.error(context, localizations.invalidCredentials);
      }
    }
  }
}
