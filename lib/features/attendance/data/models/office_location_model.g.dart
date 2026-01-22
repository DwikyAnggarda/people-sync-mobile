// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficeLocationModel _$OfficeLocationModelFromJson(Map<String, dynamic> json) =>
    OfficeLocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radiusMeters: (json['radius_meters'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$OfficeLocationModelToJson(
  OfficeLocationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'radius_meters': instance.radiusMeters,
  'is_active': instance.isActive,
};
