/// Auth Repository
/// Handles authentication API calls
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/token_manager.dart';
import '../models/models.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    tokenManager: ref.watch(tokenManagerProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

/// Auth Repository class
class AuthRepository {
  final ApiClient _apiClient;
  final TokenManager _tokenManager;
  final SecureStorage _secureStorage;

  AuthRepository({
    required ApiClient apiClient,
    required TokenManager tokenManager,
    required SecureStorage secureStorage,
  }) : _apiClient = apiClient,
       _tokenManager = tokenManager,
       _secureStorage = secureStorage;

  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data as Map<String, dynamic>;

    if (data['success'] != true) {
      throw BadRequestException(message: data['message'] ?? 'Login gagal');
    }

    final authResponse = AuthResponseModel.fromJson(
      data['data'] as Map<String, dynamic>,
    );

    // Check if user has employee data
    if (authResponse.employee == null) {
      throw const ForbiddenException(
        message: 'Akun Anda tidak terdaftar sebagai karyawan',
      );
    }

    // Save token and user data
    await _tokenManager.saveToken(authResponse.token, authResponse.expiresIn);
    await _secureStorage.saveUserData(jsonEncode(authResponse.user.toJson()));
    await _secureStorage.saveEmployeeData(
      jsonEncode(authResponse.employee!.toJson()),
    );

    return authResponse;
  }

  /// Get current authenticated user
  Future<AuthResponseModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.me);

    final data = response.data as Map<String, dynamic>;

    if (data['success'] != true) {
      throw const UnauthorizedException();
    }

    return AuthResponseModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Refresh the access token
  Future<String?> refreshToken() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.refresh);

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final responseData = data['data'] as Map<String, dynamic>;
        final newToken = responseData['token'] as String;
        final expiresIn = responseData['expires_in'] as int? ?? 3600;

        await _tokenManager.saveToken(newToken, expiresIn);
        return newToken;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // Ignore logout API errors
    } finally {
      // Always clear local data
      await _tokenManager.clearToken();
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenManager.isTokenValid();
  }

  /// Get cached user data
  Future<UserModel?> getCachedUser() async {
    final userJson = await _secureStorage.getUserData();
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  /// Get cached employee data
  Future<EmployeeModel?> getCachedEmployee() async {
    final employeeJson = await _secureStorage.getEmployeeData();
    if (employeeJson == null) return null;
    return EmployeeModel.fromJson(
      jsonDecode(employeeJson) as Map<String, dynamic>,
    );
  }
}
