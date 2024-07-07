import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/basic_entity.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
part 'room.g.dart';

@JsonSerializable()
class Room extends BasicEntity {
  final List<Equipement> initialEquipments;
  final int capacity;
  final String name;

  Room(
    int id,
    int creationDate,
    int lastUpdate, {
    required this.initialEquipments,
    required this.capacity,
    required this.name,
  }) : super(
          id,
          creationDate,
          lastUpdate,
        );
  factory Room.fromJson(Map<String, dynamic> json) {
    return _$RoomFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
