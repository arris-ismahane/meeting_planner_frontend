// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingInput _$MeetingInputFromJson(Map<String, dynamic> json) => MeetingInput(
      name: json['name'] as String,
      typeId: (json['typeId'] as num).toInt(),
      startDate: (json['startDate'] as num).toInt(),
      endDate: (json['endDate'] as num).toInt(),
      nbParticipants: (json['nbParticipants'] as num).toInt(),
    );

Map<String, dynamic> _$MeetingInputToJson(MeetingInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'typeId': instance.typeId,
      'nbParticipants': instance.nbParticipants,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
