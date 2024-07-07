import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/enums/meeting_type.dart';
part 'meeting_requirement_input.g.dart';

@JsonSerializable()
class MeetingRequirementInput {
  final List<int> requiredEquipementIds;
  final MeetingType type;

  MeetingRequirementInput({
    required this.type,
    required this.requiredEquipementIds,
  });
  factory MeetingRequirementInput.fromJson(Map<String, dynamic> json) =>
      _$MeetingRequirementInputFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingRequirementInputToJson(this);
}
