import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/basic_entity.dart';
import 'package:meeting_planner/src/model/enums/role.dart';
part 'admin.g.dart';

@JsonSerializable()
class Admin extends BasicEntity {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final List<Role> roles;
  Admin(
    int id,
    int creationDate,
    int lastUpdate, {
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.roles,
  }) : super(
          id,
          creationDate,
          lastUpdate,
        );
  factory Admin.fromJson(Map<String, dynamic> json) {
    return _$AdminFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AdminToJson(this);
}
