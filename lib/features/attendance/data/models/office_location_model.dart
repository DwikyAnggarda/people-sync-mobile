/// Office Location Model
library;

import 'package:json_annotation/json_annotation.dart';

part 'office_location_model.g.dart';

@JsonSerializable()
class OfficeLocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'radius_meters')
  final double radiusMeters;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const OfficeLocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.isActive = true,
  });

  factory OfficeLocationModel.fromJson(Map<String, dynamic> json) =>
      _$OfficeLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfficeLocationModelToJson(this);
}
