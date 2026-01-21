/// Auth Response Model
/// Response from login API
library;

import 'package:json_annotation/json_annotation.dart';

import 'employee_model.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String token;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  final UserModel user;
  final EmployeeModel? employee;

  const AuthResponseModel({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
    this.employee,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
