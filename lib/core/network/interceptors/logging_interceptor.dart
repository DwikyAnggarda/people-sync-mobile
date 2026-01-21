/// Logging Interceptor
/// Logs HTTP requests and responses for debugging
library;

import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log('→ ${options.method} ${options.uri}', name: 'HTTP');

      // Log headers (hide sensitive data)
      final safeHeaders = Map<String, dynamic>.from(options.headers);
      if (safeHeaders.containsKey('Authorization')) {
        safeHeaders['Authorization'] = 'Bearer [HIDDEN]';
      }
      developer.log('Headers: $safeHeaders', name: 'HTTP');

      // Log request body (if not too large)
      if (options.data != null) {
        final dataString = options.data.toString();
        if (dataString.length < 500) {
          // Hide password in logs
          String safeData = dataString;
          if (safeData.contains('password')) {
            safeData = safeData.replaceAll(
              RegExp(r'password["\s:]+[^,}\]]+'),
              'password: [HIDDEN]',
            );
          }
          developer.log('Body: $safeData', name: 'HTTP');
        } else {
          developer.log(
            'Body: [${dataString.length} characters]',
            name: 'HTTP',
          );
        }
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '← ${response.statusCode} ${response.requestOptions.uri}',
        name: 'HTTP',
      );

      // Log response data (if not too large)
      final dataString = response.data.toString();
      if (dataString.length < 1000) {
        // Hide token in logs
        String safeData = dataString;
        if (safeData.contains('token')) {
          safeData = safeData.replaceAll(
            RegExp(r'token["\s:]+[^,}\]]+'),
            'token: [HIDDEN]',
          );
        }
        developer.log('Response: $safeData', name: 'HTTP');
      } else {
        developer.log(
          'Response: [${dataString.length} characters]',
          name: 'HTTP',
        );
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      developer.log(
        '✗ ${err.type} ${err.requestOptions.uri}',
        name: 'HTTP',
        error: err.message,
      );

      if (err.response != null) {
        developer.log('Status: ${err.response?.statusCode}', name: 'HTTP');
        developer.log('Response: ${err.response?.data}', name: 'HTTP');
      }
    }
    handler.next(err);
  }
}
