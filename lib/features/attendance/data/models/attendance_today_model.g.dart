// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_today_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceTodayModel _$AttendanceTodayModelFromJson(
  Map<String, dynamic> json,
) => AttendanceTodayModel(
  id: (json['id'] as num?)?.toInt(),
  date: json['date'] as String? ?? '',
  clockInAt: json['clock_in_at'] as String?,
  clockOutAt: json['clock_out_at'] as String?,
  isWorkingDay: json['is_working_day'] as bool? ?? true,
  isHoliday: json['is_holiday'] as bool? ?? false,
  canClockIn: json['can_clock_in'] as bool? ?? false,
  canClockOut: json['can_clock_out'] as bool? ?? false,
  isLate: json['is_late'] as bool? ?? false,
  lateDurationMinutes: (json['late_duration_minutes'] as num?)?.toInt(),
  lateDurationFormatted: json['late_duration_formatted'] as String?,
  workSchedule: json['work_schedule'] == null
      ? null
      : WorkScheduleModel.fromJson(
          json['work_schedule'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AttendanceTodayModelToJson(
  AttendanceTodayModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'clock_in_at': instance.clockInAt,
  'clock_out_at': instance.clockOutAt,
  'is_working_day': instance.isWorkingDay,
  'is_holiday': instance.isHoliday,
  'can_clock_in': instance.canClockIn,
  'can_clock_out': instance.canClockOut,
  'is_late': instance.isLate,
  'late_duration_minutes': instance.lateDurationMinutes,
  'late_duration_formatted': instance.lateDurationFormatted,
  'work_schedule': instance.workSchedule,
};

WorkScheduleModel _$WorkScheduleModelFromJson(Map<String, dynamic> json) =>
    WorkScheduleModel(
      workStartTime: json['work_start_time'] as String? ?? '08:00',
      workEndTime: json['work_end_time'] as String? ?? '17:00',
    );

Map<String, dynamic> _$WorkScheduleModelToJson(WorkScheduleModel instance) =>
    <String, dynamic>{
      'work_start_time': instance.workStartTime,
      'work_end_time': instance.workEndTime,
    };
