/// Leave Repository
/// Handles leave API operations
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/leave_model.dart';

/// Provider for LeaveRepository
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaveRepository(apiClient);
});

class LeaveRepository {
  final ApiClient _apiClient;

  LeaveRepository(this._apiClient);

  /// Get list of leave requests
  Future<List<LeaveModel>> getLeaves({
    int page = 1,
    int perPage = 15,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};
    if (status != null) {
      queryParams['status'] = status;
    }

    final response = await _apiClient.get(
      ApiEndpoints.leaves,
      queryParameters: queryParams,
    );

    final data = response.data as Map<String, dynamic>;
    final leaves = (data['data'] as List)
        .map((e) => LeaveModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return leaves;
  }

  /// Create new leave request
  Future<LeaveModel> createLeave(LeaveRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.leaves,
      data: request.toJson(),
    );

    final data = response.data as Map<String, dynamic>;
    return LeaveModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Cancel leave request
  Future<void> cancelLeave(int id) async {
    await _apiClient.delete(ApiEndpoints.leaveDetail(id));
  }
}
