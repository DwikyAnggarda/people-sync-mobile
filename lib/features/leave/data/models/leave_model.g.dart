// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => LeaveModel(
  id: (json['id'] as num).toInt(),
  leaveType: json['leave_type'] as String,
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
  reason: json['reason'] as String?,
  status: json['status'] as String? ?? 'pending',
  totalDays: (json['total_days'] as num?)?.toInt() ?? 1,
  approvedBy: json['approved_by'] as String?,
  approvedAt: json['approved_at'] as String?,
  rejectedReason: json['rejected_reason'] as String?,
  createdAt: json['created_at'] as String? ?? '',
);

Map<String, dynamic> _$LeaveModelToJson(LeaveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leave_type': instance.leaveType,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'reason': instance.reason,
      'status': instance.status,
      'total_days': instance.totalDays,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt,
      'rejected_reason': instance.rejectedReason,
      'created_at': instance.createdAt,
    };

LeaveRequestModel _$LeaveRequestModelFromJson(Map<String, dynamic> json) =>
    LeaveRequestModel(
      leaveType: json['leave_type'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$LeaveRequestModelToJson(LeaveRequestModel instance) =>
    <String, dynamic>{
      'leave_type': instance.leaveType,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'reason': instance.reason,
    };
