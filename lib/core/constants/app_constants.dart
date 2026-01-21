/// App Constants
/// Contains all application-wide constants
library;

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'PeopleSync Mobile';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String tokenExpiryKey = 'token_expiry';
  static const String userDataKey = 'user_data';
  static const String employeeDataKey = 'employee_data';

  // Geofencing
  static const double defaultGeofenceRadiusMeters = 100.0;
}

/// Error Messages in Indonesian
class ErrorMessages {
  ErrorMessages._();

  static const String noInternet = 'Tidak ada koneksi internet';
  static const String serverError = 'Terjadi kesalahan pada server';
  static const String sessionExpired =
      'Sesi Anda telah berakhir, silakan login kembali';
  static const String invalidCredentials = 'Email atau password salah';
  static const String notEmployee =
      'Akun Anda tidak terdaftar sebagai karyawan';
  static const String locationError = 'Tidak dapat mengakses lokasi';
  static const String outsideGeofence = 'Anda berada di luar area kantor';
  static const String alreadyClockedIn =
      'Anda sudah melakukan clock in hari ini';
  static const String notClockedIn = 'Anda belum melakukan clock in hari ini';
  static const String unknownError = 'Terjadi kesalahan yang tidak diketahui';
  static const String timeout = 'Koneksi timeout, silakan coba lagi';
  static const String validationError = 'Terjadi kesalahan validasi';
  static const String unauthorized = 'Anda tidak memiliki akses';
  static const String forbidden = 'Akses ditolak';
}

/// Success Messages in Indonesian
class SuccessMessages {
  SuccessMessages._();

  static const String loginSuccess = 'Login berhasil';
  static const String logoutSuccess = 'Logout berhasil';
  static const String clockInSuccess = 'Clock in berhasil';
  static const String clockOutSuccess = 'Clock out berhasil';
  static const String leaveRequestSuccess = 'Pengajuan cuti berhasil';
  static const String leaveCancelSuccess = 'Pengajuan cuti dibatalkan';
  static const String overtimeRequestSuccess = 'Pengajuan lembur berhasil';
  static const String overtimeCancelSuccess = 'Pengajuan lembur dibatalkan';
}
