import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/admin.dart';

part 'auth_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class AuthResult {
  final String token;
  final Admin admin;

  AuthResult(this.admin, this.token);

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return _$AuthResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AuthResultToJson(this);
}
