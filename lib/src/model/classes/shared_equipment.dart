import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/basic_entity.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
part 'shared_equipment.g.dart';

@JsonSerializable()
class SharedEquipment extends BasicEntity {
  final Equipement equipment;
  final int total;

  SharedEquipment(
    int id,
    int creationDate,
    int lastUpdate, {
    required this.equipment,
    required this.total,
  }) : super(
          id,
          creationDate,
          lastUpdate,
        );
  factory SharedEquipment.fromJson(Map<String, dynamic> json) {
    return _$SharedEquipmentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SharedEquipmentToJson(this);
}
