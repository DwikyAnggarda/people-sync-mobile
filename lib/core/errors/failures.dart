/// Failure classes for error handling with Either pattern
library;

import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server failure (API errors)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, super.code, this.statusCode});

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Network failure (no internet)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Tidak ada koneksi internet',
    super.code = 'NETWORK_ERROR',
  });
}

/// Cache failure (local storage)
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Gagal mengakses penyimpanan lokal',
    super.code = 'CACHE_ERROR',
  });
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({
    super.message = 'Terjadi kesalahan validasi',
    super.code = 'VALIDATION_ERROR',
    this.errors = const {},
  });

  @override
  List<Object?> get props => [message, code, errors];
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code = 'AUTH_ERROR'});
}

/// Location failure
class LocationFailure extends Failure {
  const LocationFailure({
    super.message = 'Tidak dapat mengakses lokasi',
    super.code = 'LOCATION_ERROR',
  });
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Izin akses ditolak',
    super.code = 'PERMISSION_DENIED',
  });
}
