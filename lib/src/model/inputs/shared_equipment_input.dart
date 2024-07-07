import 'package:json_annotation/json_annotation.dart';
part 'shared_equipment_input.g.dart';

@JsonSerializable()
class SharedEquipmentInput {
  final int equipmentId;
  final int total;

  SharedEquipmentInput({
    required this.total,
    required this.equipmentId,
  });
  factory SharedEquipmentInput.fromJson(Map<String, dynamic> json) =>
      _$SharedEquipmentInputFromJson(json);
  Map<String, dynamic> toJson() => _$SharedEquipmentInputToJson(this);
}
