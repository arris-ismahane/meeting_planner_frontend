import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/basic_entity.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/model/enums/meeting_type.dart';
part 'meeting_requirement.g.dart';

@JsonSerializable()
class MeetingRequirement extends BasicEntity {
  final List<Equipement> requiredEquipements;
  final MeetingType type;

  MeetingRequirement(
    int id,
    int creationDate,
    int lastUpdate, {
    required this.requiredEquipements,
    required this.type,
  }) : super(
          id,
          creationDate,
          lastUpdate,
        );
  factory MeetingRequirement.fromJson(Map<String, dynamic> json) {
    return _$MeetingRequirementFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MeetingRequirementToJson(this);
}
