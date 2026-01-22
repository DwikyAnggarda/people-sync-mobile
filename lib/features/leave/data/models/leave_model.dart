/// Leave Model
/// For leave requests
library;

import 'package:json_annotation/json_annotation.dart';

part 'leave_model.g.dart';

@JsonSerializable()
class LeaveModel {
  final int id;
  @JsonKey(name: 'leave_type')
  final String leaveType;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  final String? reason;
  @JsonKey(defaultValue: 'pending')
  final String status;
  @JsonKey(name: 'total_days', defaultValue: 1)
  final int totalDays;
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  @JsonKey(name: 'rejected_reason')
  final String? rejectedReason;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;

  const LeaveModel({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.reason,
    required this.status,
    required this.totalDays,
    this.approvedBy,
    this.approvedAt,
    this.rejectedReason,
    required this.createdAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveModelToJson(this);

  /// Get leave type label in Indonesian
  String get leaveTypeLabel {
    switch (leaveType) {
      case 'annual':
        return 'Cuti Tahunan';
      case 'sick':
        return 'Sakit';
      case 'permission':
        return 'Izin';
      case 'unpaid':
        return 'Cuti Tanpa Gaji';
      default:
        return leaveType;
    }
  }

  /// Check if leave can be cancelled
  bool get canCancel => status == 'pending';

  /// Get formatted date range
  String get dateRange {
    try {
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      final startStr = '${start.day}/${start.month}/${start.year}';
      final endStr = '${end.day}/${end.month}/${end.year}';
      if (startDate == endDate) {
        return startStr;
      }
      return '$startStr - $endStr';
    } catch (e) {
      return '$startDate - $endDate';
    }
  }
}

/// Leave request payload
@JsonSerializable()
class LeaveRequestModel {
  @JsonKey(name: 'leave_type')
  final String leaveType;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  final String? reason;

  const LeaveRequestModel({
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.reason,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveRequestModelToJson(this);
}
