/// Overtime Repository
/// Handles overtime API operations
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/overtime_model.dart';

/// Provider for OvertimeRepository
final overtimeRepositoryProvider = Provider<OvertimeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OvertimeRepository(apiClient);
});

class OvertimeRepository {
  final ApiClient _apiClient;

  OvertimeRepository(this._apiClient);

  /// Get list of overtime requests
  Future<List<OvertimeModel>> getOvertimes({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};
    if (status != null) {
      queryParams['status'] = status;
    }

    final response = await _apiClient.get(
      ApiEndpoints.overtimes,
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>;
    final overtimes = (data['data'] as List)
        .map((e) => OvertimeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return overtimes;
  }

  /// Create new overtime request
  Future<OvertimeModel> createOvertime(OvertimeRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.overtimes,
      data: request.toJson(),
    );

    final data = response.data as Map<String, dynamic>;
    return OvertimeModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Cancel overtime request
  Future<void> cancelOvertime(int id) async {
    await _apiClient.delete(ApiEndpoints.overtimeDetail(id));
  }
}
