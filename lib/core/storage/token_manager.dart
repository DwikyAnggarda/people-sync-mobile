/// Token Manager
/// Handles JWT token lifecycle: storage, validation, refresh
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import 'secure_storage.dart';

/// Provider for TokenManager
final tokenManagerProvider = Provider<TokenManager>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return TokenManager(secureStorage);
});

/// Token Manager class
class TokenManager {
  final SecureStorage _secureStorage;

  TokenManager(this._secureStorage);

  /// Save token with its expiry time
  /// [expiresIn] is the token validity duration in seconds
  Future<void> saveToken(String token, int expiresIn) async {
    await _secureStorage.saveAccessToken(token);

    // Calculate expiry time
    final expiry = DateTime.now().add(Duration(seconds: expiresIn));
    await _secureStorage.saveTokenExpiry(expiry);
  }

  /// Get current access token
  Future<String?> getToken() async {
    return await _secureStorage.getAccessToken();
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    return await _secureStorage.hasToken();
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    final expiry = await _secureStorage.getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  /// Check if token needs refresh (within threshold of expiry)
  /// Returns true if token expires within [ApiConfig.tokenRefreshThresholdSeconds]
  Future<bool> shouldRefreshToken() async {
    final expiry = await _secureStorage.getTokenExpiry();
    if (expiry == null) return true;

    final refreshThreshold = DateTime.now().add(
      Duration(seconds: ApiConfig.tokenRefreshThresholdSeconds),
    );

    return expiry.isBefore(refreshThreshold);
  }

  /// Get remaining token validity in seconds
  Future<int> getTokenRemainingSeconds() async {
    final expiry = await _secureStorage.getTokenExpiry();
    if (expiry == null) return 0;

    final remaining = expiry.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Clear token (for logout)
  Future<void> clearToken() async {
    await _secureStorage.clearAll();
  }

  /// Validate token exists and is not expired
  Future<bool> isTokenValid() async {
    final hasToken = await this.hasToken();
    if (!hasToken) return false;

    final isExpired = await isTokenExpired();
    return !isExpired;
  }
}
