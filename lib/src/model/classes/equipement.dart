import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/basic_entity.dart';

part 'equipement.g.dart';

@JsonSerializable()
class Equipement extends BasicEntity {
  final String name;

  Equipement(
    int id,
    int creationDate,
    int lastUpdate, {
    required this.name,
  }) : super(
          id,
          creationDate,
          lastUpdate,
        );
  factory Equipement.fromJson(Map<String, dynamic> json) {
    return _$EquipementFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EquipementToJson(this);
}
