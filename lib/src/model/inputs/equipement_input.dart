import 'package:json_annotation/json_annotation.dart';
part 'equipement_input.g.dart';

@JsonSerializable()
class EquipementInput {
  final String name;

  EquipementInput({
    required this.name,
  });
  factory EquipementInput.fromJson(Map<String, dynamic> json) =>
      _$EquipementInputFromJson(json);
  Map<String, dynamic> toJson() => _$EquipementInputToJson(this);
}
