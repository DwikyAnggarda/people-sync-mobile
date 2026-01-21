/// Token Refresh Interceptor
/// Automatically refreshes token when it's about to expire
library;

import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../../errors/exceptions.dart';
import '../../storage/token_manager.dart';

/// Callback type for refreshing token
typedef TokenRefreshCallback = Future<String?> Function();

/// Callback type for handling logout (when refresh fails)
typedef LogoutCallback = Future<void> Function();

class TokenRefreshInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final TokenRefreshCallback _refreshToken;
  final LogoutCallback _onLogout;

  bool _isRefreshing = false;

  TokenRefreshInterceptor({
    required TokenManager tokenManager,
    required TokenRefreshCallback refreshToken,
    required LogoutCallback onLogout,
  }) : _tokenManager = tokenManager,
       _refreshToken = refreshToken,
       _onLogout = onLogout;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip for login and refresh endpoints
    final noTokenCheck = ['/auth/login', '/auth/refresh'];
    final shouldSkip = noTokenCheck.any((path) => options.path.contains(path));

    if (!shouldSkip && !_isRefreshing) {
      // Check if token needs refresh
      final shouldRefresh = await _tokenManager.shouldRefreshToken();
      if (shouldRefresh) {
        await _tryRefreshToken();
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      // Try to refresh token
      final newToken = await _tryRefreshToken();

      if (newToken != null) {
        // Retry the original request with new token
        try {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final dio = Dio();
          dio.options.baseUrl = options.baseUrl;
          dio.options.connectTimeout = ApiConfig.connectTimeout;
          dio.options.receiveTimeout = ApiConfig.receiveTimeout;

          final response = await dio.fetch(options);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      } else {
        // Refresh failed, logout
        await _onLogout();
      }
    }

    handler.next(err);
  }

  Future<String?> _tryRefreshToken() async {
    if (_isRefreshing) return null;

    _isRefreshing = true;
    try {
      developer.log('Refreshing token...', name: 'AUTH');
      final newToken = await _refreshToken();
      if (newToken != null) {
        developer.log('Token refreshed successfully', name: 'AUTH');
      }
      return newToken;
    } catch (e) {
      developer.log('Token refresh failed: $e', name: 'AUTH');
      throw UnauthorizedException(originalError: e);
    } finally {
      _isRefreshing = false;
    }
  }
}
