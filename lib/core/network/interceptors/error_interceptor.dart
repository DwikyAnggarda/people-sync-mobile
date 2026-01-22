/// Error Interceptor
/// Transforms Dio errors to app-specific exceptions
library;

import 'package:dio/dio.dart';

import '../../errors/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioErrorToException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  AppException _mapDioErrorToException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(originalError: error);

      case DioExceptionType.connectionError:
        return NetworkException(originalError: error);

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const BadRequestException(message: 'Permintaan dibatalkan');

      case DioExceptionType.badCertificate:
        return const ServerException(message: 'Sertifikat server tidak valid');

      case DioExceptionType.unknown:
        // Check if it's a connection error
        if (error.error.toString().contains('SocketException') ||
            error.error.toString().contains('Connection refused')) {
          return NetworkException(originalError: error);
        }
        return ServerException(
          message: 'Terjadi kesalahan yang tidak diketahui',
          originalError: error,
        );
    }
  }

  AppException _handleBadResponse(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Extract message from API response
    String message = 'Terjadi kesalahan pada server';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message, originalError: error);

      case 401:
        return UnauthorizedException(message: message, originalError: error);

      case 403:
        return ForbiddenException(message: message, originalError: error);

      case 404:
        return NotFoundException(message: message, originalError: error);

      case 422:
        // Validation errors
        Map<String, List<String>> errors = {};
        if (data is Map<String, dynamic> && data['errors'] != null) {
          final errorsData = data['errors'] as Map<String, dynamic>;
          errors = errorsData.map((key, value) {
            if (value is List) {
              return MapEntry(key, value.cast<String>());
            }
            return MapEntry(key, [value.toString()]);
          });
        }
        return ValidationException(
          message: message,
          errors: errors,
          originalError: error,
        );

      case 429:
        // Rate limit
        final retryAfter = response?.headers.value('Retry-After');
        Duration? retryDuration;
        if (retryAfter != null) {
          final seconds = int.tryParse(retryAfter);
          if (seconds != null) {
            retryDuration = Duration(seconds: seconds);
          }
        }
        return RateLimitException(
          message: message,
          retryAfter: retryDuration,
          originalError: error,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server sedang mengalami gangguan',
          statusCode: statusCode,
          originalError: error,
        );

      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
          originalError: error,
        );
    }
  }
}
