/// Input Validators
/// Utility functions for form validation
library;

class Validators {
  Validators._();

  /// Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Required field validator
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    return null;
  }

  /// Date validator (must not be empty)
  static String? validateDate(DateTime? value, [String? fieldName]) {
    if (value == null) {
      return '${fieldName ?? 'Tanggal'} tidak boleh kosong';
    }
    return null;
  }

  /// Future date validator
  static String? validateFutureDate(DateTime? value, [String? fieldName]) {
    if (value == null) {
      return '${fieldName ?? 'Tanggal'} tidak boleh kosong';
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (value.isBefore(todayDate)) {
      return '${fieldName ?? 'Tanggal'} tidak boleh di masa lalu';
    }

    return null;
  }

  /// Date range validator
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return 'Tanggal mulai tidak boleh kosong';
    }

    if (endDate == null) {
      return 'Tanggal selesai tidak boleh kosong';
    }

    if (endDate.isBefore(startDate)) {
      return 'Tanggal selesai harus setelah tanggal mulai';
    }

    return null;
  }

  /// Time range validator
  static String? validateTimeRange(String? startTime, String? endTime) {
    if (startTime == null || startTime.isEmpty) {
      return 'Waktu mulai tidak boleh kosong';
    }

    if (endTime == null || endTime.isEmpty) {
      return 'Waktu selesai tidak boleh kosong';
    }

    // Parse times (HH:mm format)
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');

    if (startParts.length != 2 || endParts.length != 2) {
      return 'Format waktu tidak valid';
    }

    final startMinutes =
        int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
    final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    if (endMinutes <= startMinutes) {
      return 'Waktu selesai harus setelah waktu mulai';
    }

    return null;
  }
}
