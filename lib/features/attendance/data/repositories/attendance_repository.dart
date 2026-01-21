/// Attendance Repository
/// Handles attendance API calls
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/models.dart';

/// Provider for AttendanceRepository
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(apiClient: ref.watch(apiClientProvider));
});

/// Attendance Repository class
class AttendanceRepository {
  final ApiClient _apiClient;

  AttendanceRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get today's attendance status
  Future<AttendanceTodayModel> getTodayAttendance() async {
    final response = await _apiClient.get(ApiEndpoints.attendanceToday);

    final data = response.data as Map<String, dynamic>;
    return AttendanceTodayModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Get attendance history
  Future<List<AttendanceModel>> getAttendanceHistory({
    int? month,
    int? year,
    int page = 1,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;

    final response = await _apiClient.get(
      ApiEndpoints.attendances,
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>;
    final listData = data['data'] as List<dynamic>;

    return listData
        .map((item) => AttendanceModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Get attendance summary for a month
  Future<AttendanceSummaryModel> getAttendanceSummary({
    int? month,
    int? year,
  }) async {
    final queryParams = <String, dynamic>{};
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;

    final response = await _apiClient.get(
      ApiEndpoints.attendanceSummary,
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>;
    return AttendanceSummaryModel.fromJson(
      data['data'] as Map<String, dynamic>,
    );
  }

  /// Clock in
  Future<AttendanceTodayModel> clockIn({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.clockIn,
      data: {'latitude': latitude, 'longitude': longitude},
    );

    final data = response.data as Map<String, dynamic>;
    return AttendanceTodayModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Clock out
  Future<AttendanceTodayModel> clockOut({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.clockOut,
      data: {'latitude': latitude, 'longitude': longitude},
    );

    final data = response.data as Map<String, dynamic>;
    return AttendanceTodayModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Get office locations for geofencing
  Future<List<OfficeLocationModel>> getOfficeLocations() async {
    final response = await _apiClient.get(ApiEndpoints.locations);

    final data = response.data as Map<String, dynamic>;
    final listData = data['data'] as List<dynamic>;

    return listData
        .map(
          (item) => OfficeLocationModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
