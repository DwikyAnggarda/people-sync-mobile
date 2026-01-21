/// Employee Model
library;

import 'package:json_annotation/json_annotation.dart';

import 'department_model.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  final int id;
  @JsonKey(name: 'employee_number')
  final String employeeNumber;
  final String name;
  final DepartmentModel? department;
  final String status;
  @JsonKey(name: 'joined_at')
  final String? joinedAt;

  const EmployeeModel({
    required this.id,
    required this.employeeNumber,
    required this.name,
    this.department,
    required this.status,
    this.joinedAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  /// Check if employee is active
  bool get isActive => status == 'active';
}
