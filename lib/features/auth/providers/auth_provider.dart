/// Auth State
/// State management for authentication
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import '../data/repositories/auth_repository.dart';

/// Auth state enum
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Auth state class
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final EmployeeModel? employee;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.employee,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    EmployeeModel? employee,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      employee: employee ?? this.employee,
      errorMessage: errorMessage,
    );
  }

  /// Factory for loading state
  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading);
  }

  /// Factory for authenticated state
  factory AuthState.authenticated({
    required UserModel user,
    required EmployeeModel employee,
  }) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      employee: employee,
    );
  }

  /// Factory for unauthenticated state
  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Factory for error state
  factory AuthState.error(String message) {
    return AuthState(status: AuthStatus.error, errorMessage: message);
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState());

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    state = AuthState.loading();

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // Try to get cached user data
        final user = await _authRepository.getCachedUser();
        final employee = await _authRepository.getCachedEmployee();

        if (user != null && employee != null) {
          state = AuthState.authenticated(user: user, employee: employee);
        } else {
          // Try to fetch from API
          try {
            final authResponse = await _authRepository.getCurrentUser();
            if (authResponse.employee != null) {
              state = AuthState.authenticated(
                user: authResponse.user,
                employee: authResponse.employee!,
              );
            } else {
              state = AuthState.unauthenticated();
            }
          } catch (e) {
            state = AuthState.unauthenticated();
          }
        }
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  /// Login with email and password
  Future<bool> login({required String email, required String password}) async {
    state = AuthState.loading();

    try {
      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );

      state = AuthState.authenticated(
        user: authResponse.user,
        employee: authResponse.employee!,
      );

      return true;
    } catch (e) {
      String message = 'Login gagal';
      if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      }
      state = AuthState.error(message);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = AuthState.loading();

    try {
      await _authRepository.logout();
    } finally {
      state = AuthState.unauthenticated();
    }
  }

  /// Clear error and set to unauthenticated
  void clearError() {
    if (state.status == AuthStatus.error) {
      state = AuthState.unauthenticated();
    }
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
