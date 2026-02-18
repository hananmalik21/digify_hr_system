import 'package:digify_hr_system/features/auth/data/datasources/auth_local_storage.dart';
import 'package:digify_hr_system/features/auth/data/datasources/hive_auth_local_storage.dart';
import 'package:digify_hr_system/features/auth/data/utils/auth_token_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFeedback {
  const LoginFeedback({required this.success, this.errorCode});
  final bool success;
  final String? errorCode;
}

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isRestoring;
  final String? error;
  final LoginFeedback? pendingLoginFeedback;

  AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.isRestoring = false,
    this.error,
    this.pendingLoginFeedback,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isRestoring,
    String? error,
    Object? pendingLoginFeedback = _undefined,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isRestoring: isRestoring ?? this.isRestoring,
      error: error ?? this.error,
      pendingLoginFeedback: identical(pendingLoginFeedback, _undefined)
          ? this.pendingLoginFeedback
          : pendingLoginFeedback as LoginFeedback?,
    );
  }
}

const _undefined = Object();

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._storage) : super(AuthState(isAuthenticated: false, isRestoring: true)) {
    _restoreSession();
  }

  final AuthLocalStorage _storage;

  Future<void> _restoreSession() async {
    try {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        state = state.copyWith(isAuthenticated: true, isRestoring: false);
      } else {
        state = state.copyWith(isRestoring: false);
      }
    } catch (_) {
      state = state.copyWith(isRestoring: false);
    }
  }

  Future<void> login(String email, String password, {required bool rememberMe}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final trimmedEmail = email.trim().toLowerCase();
      final trimmedPassword = password.trim();

      const allowedCredentials = [
        {'email': 'admin@digify.com', 'password': 'Digify@@2025'},
        {'email': 'test@digify.com', 'password': 'test123'},
        {'email': 'admin@digify.com', 'password': 'admin123'},
      ];

      final isValid = allowedCredentials.any(
        (cred) => cred['email']!.toLowerCase() == trimmedEmail && cred['password'] == trimmedPassword,
      );

      if (isValid) {
        final token = generateAuthToken();
        await _storage.saveToken(token);
        await _storage.setRememberMe(rememberMe);
        if (rememberMe) {
          await _storage.setSavedEmail(trimmedEmail);
        } else {
          await _storage.setSavedEmail(null);
        }
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          pendingLoginFeedback: const LoginFeedback(success: true),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'invalid_credentials',
          pendingLoginFeedback: const LoginFeedback(success: false, errorCode: 'invalid_credentials'),
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'network_error',
        pendingLoginFeedback: const LoginFeedback(success: false, errorCode: 'network_error'),
      );
    }
  }

  void clearPendingLoginFeedback() {
    state = state.copyWith(pendingLoginFeedback: null);
  }

  Future<void> signup(String fullName, String email, String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (fullName.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        final token = generateAuthToken();
        await _storage.saveToken(token);
        state = state.copyWith(isAuthenticated: true, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'invalid_information');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'network_error');
    }
  }

  Future<void> logout() async {
    await _storage.clearToken();
    state = AuthState(isAuthenticated: false);
  }
}

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return HiveAuthLocalStorage();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storage = ref.watch(authLocalStorageProvider);
  return AuthNotifier(storage);
});

class LoginFormState {
  final bool rememberMe;
  final String? savedEmail;
  final bool initialLoadDone;
  final bool savedEmailConsumed;

  const LoginFormState({
    this.rememberMe = false,
    this.savedEmail,
    this.initialLoadDone = false,
    this.savedEmailConsumed = false,
  });

  LoginFormState copyWith({bool? rememberMe, String? savedEmail, bool? initialLoadDone, bool? savedEmailConsumed}) {
    return LoginFormState(
      rememberMe: rememberMe ?? this.rememberMe,
      savedEmail: savedEmail ?? this.savedEmail,
      initialLoadDone: initialLoadDone ?? this.initialLoadDone,
      savedEmailConsumed: savedEmailConsumed ?? this.savedEmailConsumed,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier(this._storage) : super(const LoginFormState()) {
    _loadInitial();
  }

  final AuthLocalStorage _storage;

  Future<void> _loadInitial() async {
    try {
      final rememberMe = await _storage.getRememberMe();
      final savedEmail = await _storage.getSavedEmail();
      state = state.copyWith(rememberMe: rememberMe, savedEmail: savedEmail, initialLoadDone: true);
    } catch (_) {
      state = state.copyWith(initialLoadDone: true);
    }
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  String? consumeSavedEmailForPrefill() {
    if (state.savedEmailConsumed || state.savedEmail == null) return null;
    final email = state.savedEmail;
    state = state.copyWith(savedEmailConsumed: true);
    return email;
  }

  void allowPrefillAgain() {
    state = state.copyWith(savedEmailConsumed: false);
  }
}

final loginFormStateProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  final storage = ref.watch(authLocalStorageProvider);
  return LoginFormNotifier(storage);
});
