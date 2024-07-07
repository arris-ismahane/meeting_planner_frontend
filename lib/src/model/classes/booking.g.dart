// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      (json['id'] as num).toInt(),
      (json['creationDate'] as num).toInt(),
      (json['lastUpdate'] as num).toInt(),
      name: json['name'] as String,
      room: Room.fromJson(json['room'] as Map<String, dynamic>),
      nbParticipants: (json['nbParticipants'] as num).toInt(),
      startDate: (json['startDate'] as num).toInt(),
      endDate: (json['endDate'] as num).toInt(),
      bookedEquipements: (json['bookedEquipements'] as List<dynamic>)
          .map((e) => SharedEquipment.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: MeetingRequirement.fromJson(json['type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'room': instance.room,
      'name': instance.name,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'type': instance.type,
      'nbParticipants': instance.nbParticipants,
      'bookedEquipements': instance.bookedEquipements,
    };
