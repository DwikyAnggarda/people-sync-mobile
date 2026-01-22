/// Overtime Model
/// For overtime requests
library;

import 'package:json_annotation/json_annotation.dart';

part 'overtime_model.g.dart';

@JsonSerializable()
class OvertimeModel {
  final int id;
  final String date;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  final String? reason;
  @JsonKey(defaultValue: 'pending')
  final String status;
  @JsonKey(name: 'total_hours', defaultValue: 0.0)
  final double totalHours;
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  @JsonKey(name: 'rejected_reason')
  final String? rejectedReason;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;

  const OvertimeModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.reason,
    required this.status,
    required this.totalHours,
    this.approvedBy,
    this.approvedAt,
    this.rejectedReason,
    required this.createdAt,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$OvertimeModelToJson(this);

  /// Check if overtime can be cancelled
  bool get canCancel => status == 'pending';

  /// Get formatted date
  String get formattedDate {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }

  /// Get formatted time range
  String get timeRange => '$startTime - $endTime';

  /// Get formatted total hours
  String get formattedHours {
    final hours = totalHours.toInt();
    final minutes = ((totalHours - hours) * 60).round();
    if (minutes > 0) {
      return '$hours jam $minutes menit';
    }
    return '$hours jam';
  }
}

/// Overtime request payload
@JsonSerializable()
class OvertimeRequestModel {
  final String date;
  @JsonKey(name: 'start_time')
  final String startTime;
  @JsonKey(name: 'end_time')
  final String endTime;
  final String? reason;

  const OvertimeRequestModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    this.reason,
  });

  factory OvertimeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OvertimeRequestModelToJson(this);
}
