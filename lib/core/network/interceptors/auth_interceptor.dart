/// Auth Interceptor
/// Adds Bearer token to all requests
library;

import 'package:dio/dio.dart';

import '../../storage/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for login and refresh endpoints
    final noAuthPaths = ['/auth/login', '/auth/refresh'];
    final shouldSkipAuth = noAuthPaths.any(
      (path) => options.path.contains(path),
    );

    if (!shouldSkipAuth) {
      final token = await _tokenManager.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }
}
