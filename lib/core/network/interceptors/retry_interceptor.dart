/// Retry Interceptor
/// Automatically retries failed requests
library;

import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';

class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = ApiConfig.maxRetries,
    this.retryDelay = ApiConfig.retryDelay,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on specific errors
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        // Wait before retrying
        await Future.delayed(retryDelay * (retryCount + 1));

        // Increment retry count
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          // Retry the request
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.next(e);
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry on timeout or connection errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on 5xx server errors (except 501 Not Implemented)
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 500 && statusCode != 501) {
        return true;
      }
    }

    return false;
  }
}
