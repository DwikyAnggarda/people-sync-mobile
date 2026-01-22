/// API Client
/// Central Dio configuration with all interceptors
library;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../storage/token_manager.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

/// Provider for the API Client
final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return ApiClient(tokenManager: tokenManager, ref: ref);
});

/// API Client class
class ApiClient {
  late final Dio _dio;
  final TokenManager tokenManager;

  ApiClient({required this.tokenManager, required Ref ref}) {
    _dio = _createDio();
    _setupInterceptors();
  }

  Dio _createDio() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api/v1';

    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  void _setupInterceptors() {
    // Order matters! Add in this sequence:
    // 1. Logging (first, to log original request)
    // 2. Token refresh (before auth, to refresh if needed)
    // 3. Auth (add token to request)
    // 4. Retry (retry on failure)
    // 5. Error (transform errors - last, after all retries)

    _dio.interceptors.addAll([
      LoggingInterceptor(),
      TokenRefreshInterceptor(
        tokenManager: tokenManager,
        refreshToken: _refreshTokenCallback,
        onLogout: _logoutCallback,
      ),
      AuthInterceptor(tokenManager),
      RetryInterceptor(_dio),
      ErrorInterceptor(),
    ]);
  }

  /// Refresh token callback for interceptor
  Future<String?> _refreshTokenCallback() async {
    try {
      final currentToken = await tokenManager.getToken();
      if (currentToken == null) return null;

      // Create a fresh Dio without interceptors to avoid loops
      final freshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: ApiConfig.connectTimeout,
          receiveTimeout: ApiConfig.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $currentToken',
          },
        ),
      );

      final response = await freshDio.post(ApiEndpoints.refresh);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final newToken = data['token'] as String;
        final expiresIn = data['expires_in'] as int? ?? 3600;

        await tokenManager.saveToken(newToken, expiresIn);
        return newToken;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Logout callback for interceptor
  Future<void> _logoutCallback() async {
    await tokenManager.clearToken();
    // The app will redirect to login via auth state listener
  }

  /// Check network connectivity before making request
  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      throw const NetworkException();
    }
  }

  /// Extract exception from DioException
  AppException _extractException(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return ServerException(
      message: e.message ?? 'Unknown error',
      originalError: e,
    );
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _extractException(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _extractException(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _extractException(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _extractException(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _extractException(e);
    }
  }
}
