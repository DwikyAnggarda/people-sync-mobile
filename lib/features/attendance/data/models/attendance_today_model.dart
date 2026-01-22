/// Attendance Today Model
/// Today's attendance status from API
library;

import 'package:json_annotation/json_annotation.dart';

part 'attendance_today_model.g.dart';

@JsonSerializable()
class AttendanceTodayModel {
  final int? id;
  @JsonKey(defaultValue: '')
  final String date;
  @JsonKey(name: 'clock_in_at')
  final String? clockInAt;
  @JsonKey(name: 'clock_out_at')
  final String? clockOutAt;
  @JsonKey(name: 'is_working_day', defaultValue: true)
  final bool isWorkingDay;
  @JsonKey(name: 'is_holiday', defaultValue: false)
  final bool isHoliday;
  @JsonKey(name: 'can_clock_in', defaultValue: false)
  final bool canClockIn;
  @JsonKey(name: 'can_clock_out', defaultValue: false)
  final bool canClockOut;
  @JsonKey(name: 'is_late', defaultValue: false)
  final bool isLate;
  @JsonKey(name: 'late_duration_minutes')
  final int? lateDurationMinutes;
  @JsonKey(name: 'late_duration_formatted')
  final String? lateDurationFormatted;
  @JsonKey(name: 'work_schedule')
  final WorkScheduleModel? workSchedule;

  const AttendanceTodayModel({
    this.id,
    required this.date,
    this.clockInAt,
    this.clockOutAt,
    required this.isWorkingDay,
    required this.isHoliday,
    required this.canClockIn,
    required this.canClockOut,
    required this.isLate,
    this.lateDurationMinutes,
    this.lateDurationFormatted,
    this.workSchedule,
  });

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceTodayModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceTodayModelToJson(this);

  /// Check if user has clocked in
  bool get hasClockedIn => clockInAt != null;

  /// Check if user has clocked out
  bool get hasClockedOut => clockOutAt != null;

  /// Get status text
  String get statusText {
    if (!hasClockedIn) {
      return 'Belum Clock In';
    } else if (!hasClockedOut) {
      return 'Sudah Clock In';
    } else {
      return 'Sudah Clock Out';
    }
  }
}

@JsonSerializable()
class WorkScheduleModel {
  @JsonKey(name: 'work_start_time', defaultValue: '08:00')
  final String workStartTime;
  @JsonKey(name: 'work_end_time', defaultValue: '17:00')
  final String workEndTime;

  const WorkScheduleModel({
    required this.workStartTime,
    required this.workEndTime,
  });

  factory WorkScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$WorkScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkScheduleModelToJson(this);
}
