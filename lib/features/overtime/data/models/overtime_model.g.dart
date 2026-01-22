// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OvertimeModel _$OvertimeModelFromJson(Map<String, dynamic> json) =>
    OvertimeModel(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      reason: json['reason'] as String?,
      status: json['status'] as String? ?? 'pending',
      totalHours: (json['total_hours'] as num?)?.toDouble() ?? 0.0,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] as String?,
      rejectedReason: json['rejected_reason'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$OvertimeModelToJson(OvertimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'reason': instance.reason,
      'status': instance.status,
      'total_hours': instance.totalHours,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt,
      'rejected_reason': instance.rejectedReason,
      'created_at': instance.createdAt,
    };

OvertimeRequestModel _$OvertimeRequestModelFromJson(
  Map<String, dynamic> json,
) => OvertimeRequestModel(
  date: json['date'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$OvertimeRequestModelToJson(
  OvertimeRequestModel instance,
) => <String, dynamic>{
  'date': instance.date,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'reason': instance.reason,
};
