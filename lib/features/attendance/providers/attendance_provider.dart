/// Attendance Provider
/// State management for attendance features
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../data/models/models.dart';
import '../data/repositories/attendance_repository.dart';
import '../services/location_service.dart';

/// Today's attendance state
class TodayAttendanceState {
  final bool isLoading;
  final AttendanceTodayModel? attendance;
  final String? errorMessage;

  const TodayAttendanceState({
    this.isLoading = false,
    this.attendance,
    this.errorMessage,
  });

  TodayAttendanceState copyWith({
    bool? isLoading,
    AttendanceTodayModel? attendance,
    String? errorMessage,
  }) {
    return TodayAttendanceState(
      isLoading: isLoading ?? this.isLoading,
      attendance: attendance ?? this.attendance,
      errorMessage: errorMessage,
    );
  }
}

/// Today's attendance notifier
class TodayAttendanceNotifier extends StateNotifier<TodayAttendanceState> {
  final AttendanceRepository _repository;

  TodayAttendanceNotifier(this._repository)
    : super(const TodayAttendanceState());

  /// Fetch today's attendance
  Future<void> fetchTodayAttendance() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final attendance = await _repository.getTodayAttendance();
      state = state.copyWith(isLoading: false, attendance: attendance);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Update attendance after clock action
  void updateAttendance(AttendanceTodayModel attendance) {
    state = state.copyWith(attendance: attendance);
  }
}

/// Today's attendance provider
final todayAttendanceProvider =
    StateNotifierProvider<TodayAttendanceNotifier, TodayAttendanceState>((ref) {
      final repository = ref.watch(attendanceRepositoryProvider);
      return TodayAttendanceNotifier(repository);
    });

/// Office locations provider
final officeLocationsProvider = FutureProvider<List<OfficeLocationModel>>((
  ref,
) async {
  final repository = ref.watch(attendanceRepositoryProvider);
  return repository.getOfficeLocations();
});

/// Clock action state
class ClockActionState {
  final bool isLoading;
  final Position? currentPosition;
  final GeofenceResult? geofenceResult;
  final String? errorMessage;
  final String? successMessage;

  const ClockActionState({
    this.isLoading = false,
    this.currentPosition,
    this.geofenceResult,
    this.errorMessage,
    this.successMessage,
  });

  ClockActionState copyWith({
    bool? isLoading,
    Position? currentPosition,
    GeofenceResult? geofenceResult,
    String? errorMessage,
    String? successMessage,
  }) {
    return ClockActionState(
      isLoading: isLoading ?? this.isLoading,
      currentPosition: currentPosition ?? this.currentPosition,
      geofenceResult: geofenceResult ?? this.geofenceResult,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

/// Clock action notifier
class ClockActionNotifier extends StateNotifier<ClockActionState> {
  final AttendanceRepository _repository;
  final LocationService _locationService;
  final Ref _ref;

  ClockActionNotifier(this._repository, this._locationService, this._ref)
    : super(const ClockActionState());

  /// Get current location and check geofence
  Future<void> checkLocation() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      // Get current position
      final position = await _locationService.getCurrentPosition();

      // Get office locations
      final officesAsync = await _ref.read(officeLocationsProvider.future);

      // Check geofence
      final geofenceResult = _locationService.checkGeofence(
        position: position,
        offices: officesAsync,
      );

      state = state.copyWith(
        isLoading: false,
        currentPosition: position,
        geofenceResult: geofenceResult,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Perform clock in
  Future<bool> clockIn() async {
    if (state.currentPosition == null) {
      await checkLocation();
    }

    if (state.currentPosition == null) {
      return false;
    }

    if (state.geofenceResult?.isWithinGeofence != true) {
      state = state.copyWith(
        errorMessage:
            'Anda berada di luar area kantor (${state.geofenceResult?.formattedDistance ?? ""})',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repository.clockIn(
        latitude: state.currentPosition!.latitude,
        longitude: state.currentPosition!.longitude,
      );

      // Update today's attendance
      _ref.read(todayAttendanceProvider.notifier).updateAttendance(result);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Clock in berhasil!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Perform clock out
  Future<bool> clockOut() async {
    if (state.currentPosition == null) {
      await checkLocation();
    }

    if (state.currentPosition == null) {
      return false;
    }

    if (state.geofenceResult?.isWithinGeofence != true) {
      state = state.copyWith(
        errorMessage:
            'Anda berada di luar area kantor (${state.geofenceResult?.formattedDistance ?? ""})',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repository.clockOut(
        latitude: state.currentPosition!.latitude,
        longitude: state.currentPosition!.longitude,
      );

      // Update today's attendance
      _ref.read(todayAttendanceProvider.notifier).updateAttendance(result);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Clock out berhasil!',
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

/// Clock action provider
final clockActionProvider =
    StateNotifierProvider<ClockActionNotifier, ClockActionState>((ref) {
      final repository = ref.watch(attendanceRepositoryProvider);
      final locationService = ref.watch(locationServiceProvider);
      return ClockActionNotifier(repository, locationService, ref);
    });

/// Attendance history state
class AttendanceHistoryState {
  final bool isLoading;
  final List<AttendanceModel> attendances;
  final AttendanceSummaryModel? summary;
  final int selectedMonth;
  final int selectedYear;
  final String? errorMessage;

  AttendanceHistoryState({
    this.isLoading = false,
    this.attendances = const [],
    this.summary,
    int? selectedMonth,
    int? selectedYear,
    this.errorMessage,
  }) : selectedMonth = selectedMonth ?? DateTime.now().month,
       selectedYear = selectedYear ?? DateTime.now().year;

  AttendanceHistoryState copyWith({
    bool? isLoading,
    List<AttendanceModel>? attendances,
    AttendanceSummaryModel? summary,
    int? selectedMonth,
    int? selectedYear,
    String? errorMessage,
  }) {
    return AttendanceHistoryState(
      isLoading: isLoading ?? this.isLoading,
      attendances: attendances ?? this.attendances,
      summary: summary ?? this.summary,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      errorMessage: errorMessage,
    );
  }
}

/// Attendance history notifier
class AttendanceHistoryNotifier extends StateNotifier<AttendanceHistoryState> {
  final AttendanceRepository _repository;

  AttendanceHistoryNotifier(this._repository) : super(AttendanceHistoryState());

  /// Fetch attendance history
  Future<void> fetchHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final attendances = await _repository.getAttendanceHistory(
        month: state.selectedMonth,
        year: state.selectedYear,
      );

      final summary = await _repository.getAttendanceSummary(
        month: state.selectedMonth,
        year: state.selectedYear,
      );

      state = state.copyWith(
        isLoading: false,
        attendances: attendances,
        summary: summary,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Change month/year selection
  void changeMonth(int month, int year) {
    state = state.copyWith(selectedMonth: month, selectedYear: year);
    fetchHistory();
  }
}

/// Attendance history provider
final attendanceHistoryProvider =
    StateNotifierProvider<AttendanceHistoryNotifier, AttendanceHistoryState>((
      ref,
    ) {
      final repository = ref.watch(attendanceRepositoryProvider);
      return AttendanceHistoryNotifier(repository);
    });
