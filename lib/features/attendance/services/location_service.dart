/// Location Service
/// Handles GPS location and geofencing
library;

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/errors/exceptions.dart';
import '../data/models/office_location_model.dart';

/// Provider for LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Current position provider
final currentPositionProvider = FutureProvider<Position>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.getCurrentPosition();
});

/// Location Service class
class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permission
  Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Get current position
  Future<Position> getCurrentPosition() async {
    // Check if location service is enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        message: 'Layanan lokasi tidak aktif. Silakan aktifkan GPS.',
      );
    }

    // Check permission
    final permission = await checkAndRequestPermission();

    if (permission == LocationPermission.denied) {
      throw const PermissionException(
        message: 'Izin lokasi ditolak. Silakan berikan izin akses lokasi.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionException(
        message:
            'Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan.',
      );
    }

    // Get position
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (e) {
      throw LocationException(
        message: 'Gagal mendapatkan lokasi. Silakan coba lagi.',
        originalError: e,
      );
    }
  }

  /// Calculate distance between two points in meters
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Check if position is within geofence of any office location
  GeofenceResult checkGeofence({
    required Position position,
    required List<OfficeLocationModel> offices,
  }) {
    if (offices.isEmpty) {
      return GeofenceResult(
        isWithinGeofence: false,
        nearestOffice: null,
        distance: 0,
      );
    }

    OfficeLocationModel? nearestOffice;
    double minDistance = double.infinity;

    for (final office in offices) {
      final distance = calculateDistance(
        startLatitude: position.latitude,
        startLongitude: position.longitude,
        endLatitude: office.latitude,
        endLongitude: office.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestOffice = office;
      }
    }

    final isWithin =
        nearestOffice != null && minDistance <= nearestOffice.radiusMeters;

    return GeofenceResult(
      isWithinGeofence: isWithin,
      nearestOffice: nearestOffice,
      distance: minDistance,
    );
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}

/// Geofence check result
class GeofenceResult {
  final bool isWithinGeofence;
  final OfficeLocationModel? nearestOffice;
  final double distance;

  const GeofenceResult({
    required this.isWithinGeofence,
    required this.nearestOffice,
    required this.distance,
  });

  /// Get formatted distance string
  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} meter';
    }
    return '${(distance / 1000).toStringAsFixed(2)} km';
  }
}
