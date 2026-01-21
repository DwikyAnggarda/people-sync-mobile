/// API Response Model
/// Wrapper for API responses following backend format
library;

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, List<String>>? errors;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    // Parse errors if present
    Map<String, List<String>>? errors;
    if (json['errors'] != null) {
      final errorsData = json['errors'] as Map<String, dynamic>;
      errors = errorsData.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.cast<String>());
        }
        return MapEntry(key, [value.toString()]);
      });
    }

    // Parse data
    T? data;
    if (json['data'] != null && fromJsonT != null) {
      data = fromJsonT(json['data']);
    }

    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: data,
      errors: errors,
    );
  }

  /// Check if response has validation errors
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  /// Get first error for a field
  String? getFieldError(String field) {
    final fieldErrors = errors?[field];
    return fieldErrors?.isNotEmpty == true ? fieldErrors!.first : null;
  }
}

/// Paginated list response
class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return PaginatedResponse(
      data: dataList
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
      total: json['total'] as int? ?? 0,
    );
  }

  bool get hasNextPage => currentPage < lastPage;
  bool get hasPreviousPage => currentPage > 1;
  bool get isEmpty => data.isEmpty;
}
