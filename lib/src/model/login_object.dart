import 'package:json_annotation/json_annotation.dart';

part 'login_object.g.dart';

@JsonSerializable()
class LoginObject {
  final String username;

  final String password;

  LoginObject({required this.username, required this.password});

  factory LoginObject.fromJson(Map<String, dynamic> json) =>
      _$LoginObjectFromJson(json);
  Map<String, dynamic> toJson() => _$LoginObjectToJson(this);
}
