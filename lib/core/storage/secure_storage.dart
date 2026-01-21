/// Secure Storage Service
/// Wrapper around flutter_secure_storage for JWT and sensitive data
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Provider for SecureStorage
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

/// Secure storage wrapper class
class SecureStorage {
  late final FlutterSecureStorage _storage;

  SecureStorage() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: AppConstants.accessTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Gagal menyimpan token', originalError: e);
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      throw CacheException(message: 'Gagal membaca token', originalError: e);
    }
  }

  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(DateTime expiry) async {
    try {
      await _storage.write(
        key: AppConstants.tokenExpiryKey,
        value: expiry.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      throw CacheException(
        message: 'Gagal menyimpan waktu kedaluwarsa token',
        originalError: e,
      );
    }
  }

  /// Get token expiry timestamp
  Future<DateTime?> getTokenExpiry() async {
    try {
      final expiryString = await _storage.read(
        key: AppConstants.tokenExpiryKey,
      );
      if (expiryString == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
    } catch (e) {
      throw CacheException(
        message: 'Gagal membaca waktu kedaluwarsa token',
        originalError: e,
      );
    }
  }

  /// Save user data as JSON string
  Future<void> saveUserData(String userJson) async {
    try {
      await _storage.write(key: AppConstants.userDataKey, value: userJson);
    } catch (e) {
      throw CacheException(
        message: 'Gagal menyimpan data pengguna',
        originalError: e,
      );
    }
  }

  /// Get user data JSON string
  Future<String?> getUserData() async {
    try {
      return await _storage.read(key: AppConstants.userDataKey);
    } catch (e) {
      throw CacheException(
        message: 'Gagal membaca data pengguna',
        originalError: e,
      );
    }
  }

  /// Save employee data as JSON string
  Future<void> saveEmployeeData(String employeeJson) async {
    try {
      await _storage.write(
        key: AppConstants.employeeDataKey,
        value: employeeJson,
      );
    } catch (e) {
      throw CacheException(
        message: 'Gagal menyimpan data karyawan',
        originalError: e,
      );
    }
  }

  /// Get employee data JSON string
  Future<String?> getEmployeeData() async {
    try {
      return await _storage.read(key: AppConstants.employeeDataKey);
    } catch (e) {
      throw CacheException(
        message: 'Gagal membaca data karyawan',
        originalError: e,
      );
    }
  }

  /// Clear all stored data (for logout)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException(message: 'Gagal menghapus data', originalError: e);
    }
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
