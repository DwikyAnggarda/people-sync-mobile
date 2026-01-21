/// Custom Exceptions for API and App Errors
library;

/// Base exception class for all app exceptions
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network connection exception (no internet)
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Tidak ada koneksi internet',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Server error (5xx HTTP status)
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    super.message = 'Terjadi kesalahan pada server',
    super.code = 'SERVER_ERROR',
    super.originalError,
    this.statusCode,
  });
}

/// Unauthorized exception (401 - token expired or invalid)
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Sesi Anda telah berakhir, silakan login kembali',
    super.code = 'UNAUTHORIZED',
    super.originalError,
  });
}

/// Forbidden exception (403 - not allowed)
class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Akun Anda tidak terdaftar sebagai karyawan',
    super.code = 'FORBIDDEN',
    super.originalError,
  });
}

/// Validation exception (422 - form validation errors)
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException({
    super.message = 'Terjadi kesalahan validasi',
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    this.errors = const {},
  });

  /// Get first error for a specific field
  String? getFieldError(String field) {
    final fieldErrors = errors[field];
    return fieldErrors?.isNotEmpty == true ? fieldErrors!.first : null;
  }

  /// Get all field errors as a single string
  String get allFieldErrors {
    return errors.entries
        .map((e) => '${e.key}: ${e.value.join(", ")}')
        .join('\n');
  }
}

/// Timeout exception
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Koneksi timeout, silakan coba lagi',
    super.code = 'TIMEOUT',
    super.originalError,
  });
}

/// Rate limit exception (429 - too many requests)
class RateLimitException extends AppException {
  final Duration? retryAfter;

  const RateLimitException({
    super.message = 'Terlalu banyak permintaan, silakan tunggu sebentar',
    super.code = 'RATE_LIMIT',
    super.originalError,
    this.retryAfter,
  });
}

/// Bad request exception (400)
class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Permintaan tidak valid',
    super.code = 'BAD_REQUEST',
    super.originalError,
  });
}

/// Not found exception (404)
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Data tidak ditemukan',
    super.code = 'NOT_FOUND',
    super.originalError,
  });
}

/// Cache exception (local storage errors)
class CacheException extends AppException {
  const CacheException({
    super.message = 'Gagal mengakses penyimpanan lokal',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// Location exception (GPS errors)
class LocationException extends AppException {
  const LocationException({
    super.message = 'Tidak dapat mengakses lokasi',
    super.code = 'LOCATION_ERROR',
    super.originalError,
  });
}

/// Permission exception (permission denied)
class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Izin akses ditolak',
    super.code = 'PERMISSION_DENIED',
    super.originalError,
  });
}

/// Geofence exception (outside allowed area)
class GeofenceException extends AppException {
  final double? distance;
  final double? allowedRadius;

  const GeofenceException({
    super.message = 'Anda berada di luar area kantor',
    super.code = 'GEOFENCE_ERROR',
    super.originalError,
    this.distance,
    this.allowedRadius,
  });

  String get detailedMessage {
    if (distance != null && allowedRadius != null) {
      final distanceKm = distance! / 1000;
      return 'Anda berada ${distanceKm.toStringAsFixed(2)} km dari kantor. Jarak maksimal: ${allowedRadius!.toInt()} meter';
    }
    return message;
  }
}
