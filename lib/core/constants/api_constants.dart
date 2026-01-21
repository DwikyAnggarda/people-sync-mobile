/// API Constants
/// Contains all API endpoints and configuration
library;

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Attendance
  static const String attendances = '/attendances';
  static const String attendanceToday = '/attendances/today';
  static const String attendanceSummary = '/attendances/summary';
  static const String clockIn = '/attendances/clock-in';
  static const String clockOut = '/attendances/clock-out';

  // Leave
  static const String leaves = '/leaves';
  static String leaveDetail(int id) => '/leaves/$id';

  // Overtime
  static const String overtimes = '/overtimes';
  static String overtimeDetail(int id) => '/overtimes/$id';

  // Supporting Data
  static const String locations = '/locations';
  static const String holidays = '/holidays';
  static const String workSchedules = '/work-schedules';
}

class ApiConfig {
  ApiConfig._();

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Token refresh configuration
  static const int tokenRefreshThresholdSeconds =
      300; // 5 minutes before expiry
}
