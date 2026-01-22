// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      id: (json['id'] as num).toInt(),
      employeeNumber: json['employee_number'] as String,
      name: json['name'] as String,
      department: json['department'] == null
          ? null
          : DepartmentModel.fromJson(
              json['department'] as Map<String, dynamic>,
            ),
      status: json['status'] as String,
      joinedAt: json['joined_at'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_number': instance.employeeNumber,
      'name': instance.name,
      'department': instance.department,
      'status': instance.status,
      'joined_at': instance.joinedAt,
    };
