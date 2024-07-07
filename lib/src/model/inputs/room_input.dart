import 'package:json_annotation/json_annotation.dart';
part 'room_input.g.dart';

@JsonSerializable()
class RoomInput {
  final String name;
  final int capacity;
  final List<int> initialEquipmentIds;

  RoomInput({
    required this.name,
    required this.initialEquipmentIds,
    required this.capacity,
  });
  factory RoomInput.fromJson(Map<String, dynamic> json) =>
      _$RoomInputFromJson(json);
  Map<String, dynamic> toJson() => _$RoomInputToJson(this);
}
