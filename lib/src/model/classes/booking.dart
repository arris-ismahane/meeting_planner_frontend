import 'package:json_annotation/json_annotation.dart';
import 'package:meeting_planner/src/model/basic_entity.dart';
import 'package:meeting_planner/src/model/classes/meeting_requirement.dart';
import 'package:meeting_planner/src/model/classes/room.dart';
import 'package:meeting_planner/src/model/classes/shared_equipment.dart';
part 'booking.g.dart';

@JsonSerializable()
class Booking extends BasicEntity {
  final Room room;
  final String name;
  final int startDate;
  final int endDate;
  final MeetingRequirement type;
  final int nbParticipants;
  final List<SharedEquipment> bookedEquipements;
  Booking(
    int id,
    int creationDate,
    int lastUpdate, {
    required this.name,
    required this.room,
    required this.nbParticipants,
    required this.startDate,
    required this.endDate,
    required this.bookedEquipements,
    required this.type,
  }) : super(
          id,
          creationDate,
          lastUpdate,
        );
  factory Booking.fromJson(Map<String, dynamic> json) {
    return _$BookingFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
