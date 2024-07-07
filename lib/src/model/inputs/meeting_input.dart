import 'package:json_annotation/json_annotation.dart';
part 'meeting_input.g.dart';

@JsonSerializable()
class MeetingInput {
  final String name;
  final int typeId;
  final int nbParticipants;
  final int startDate;
  final int endDate;
  MeetingInput({
    required this.name,
    required this.typeId,
    required this.startDate,
    required this.endDate,
    required this.nbParticipants,
  });
  factory MeetingInput.fromJson(Map<String, dynamic> json) =>
      _$MeetingInputFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingInputToJson(this);
}
