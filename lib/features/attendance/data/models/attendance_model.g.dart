// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    AttendanceModel(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      clockInAt: json['clock_in_at'] as String?,
      clockOutAt: json['clock_out_at'] as String?,
      isLate: json['is_late'] as bool? ?? false,
      lateDurationMinutes: (json['late_duration_minutes'] as num?)?.toInt(),
      workDurationMinutes: (json['work_duration_minutes'] as num?)?.toInt(),
      status: json['status'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AttendanceModelToJson(AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'clock_in_at': instance.clockInAt,
      'clock_out_at': instance.clockOutAt,
      'is_late': instance.isLate,
      'late_duration_minutes': instance.lateDurationMinutes,
      'work_duration_minutes': instance.workDurationMinutes,
      'status': instance.status,
      'notes': instance.notes,
    };

AttendanceSummaryModel _$AttendanceSummaryModelFromJson(
  Map<String, dynamic> json,
) => AttendanceSummaryModel(
  totalPresent: (json['total_present'] as num?)?.toInt() ?? 0,
  totalLate: (json['total_late'] as num?)?.toInt() ?? 0,
  totalAbsent: (json['total_absent'] as num?)?.toInt() ?? 0,
  totalLeave: (json['total_leave'] as num?)?.toInt() ?? 0,
  totalWorkingDays: (json['total_working_days'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AttendanceSummaryModelToJson(
  AttendanceSummaryModel instance,
) => <String, dynamic>{
  'total_present': instance.totalPresent,
  'total_late': instance.totalLate,
  'total_absent': instance.totalAbsent,
  'total_leave': instance.totalLeave,
  'total_working_days': instance.totalWorkingDays,
};
