/// Attendance Model
/// For attendance history list
library;

import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable()
class AttendanceModel {
  final int id;
  final String date;
  @JsonKey(name: 'clock_in_at')
  final String? clockInAt;
  @JsonKey(name: 'clock_out_at')
  final String? clockOutAt;
  @JsonKey(name: 'is_late', defaultValue: false)
  final bool isLate;
  @JsonKey(name: 'late_duration_minutes')
  final int? lateDurationMinutes;
  @JsonKey(name: 'work_duration_minutes')
  final int? workDurationMinutes;
  final String? status;
  final String? notes;

  const AttendanceModel({
    required this.id,
    required this.date,
    this.clockInAt,
    this.clockOutAt,
    required this.isLate,
    this.lateDurationMinutes,
    this.workDurationMinutes,
    this.status,
    this.notes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceModelToJson(this);

  /// Get clock in time only (HH:mm)
  String? get clockInTimeFormatted {
    if (clockInAt == null) return null;
    try {
      final dateTime = DateTime.parse(clockInAt!);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }

  /// Get clock out time only (HH:mm)
  String? get clockOutTimeFormatted {
    if (clockOutAt == null) return null;
    try {
      final dateTime = DateTime.parse(clockOutAt!);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return null;
    }
  }

  /// Check if attendance is complete (clocked in and out)
  bool get isComplete => clockInAt != null && clockOutAt != null;
}

/// Attendance Summary Model
@JsonSerializable()
class AttendanceSummaryModel {
  @JsonKey(name: 'total_present', defaultValue: 0)
  final int totalPresent;
  @JsonKey(name: 'total_late', defaultValue: 0)
  final int totalLate;
  @JsonKey(name: 'total_absent', defaultValue: 0)
  final int totalAbsent;
  @JsonKey(name: 'total_leave', defaultValue: 0)
  final int totalLeave;
  @JsonKey(name: 'total_working_days', defaultValue: 0)
  final int totalWorkingDays;

  const AttendanceSummaryModel({
    required this.totalPresent,
    required this.totalLate,
    required this.totalAbsent,
    required this.totalLeave,
    required this.totalWorkingDays,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSummaryModelToJson(this);
}
