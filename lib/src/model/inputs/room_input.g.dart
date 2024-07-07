// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomInput _$RoomInputFromJson(Map<String, dynamic> json) => RoomInput(
      name: json['name'] as String,
      initialEquipmentIds: (json['initialEquipmentIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      capacity: (json['capacity'] as num).toInt(),
    );

Map<String, dynamic> _$RoomInputToJson(RoomInput instance) => <String, dynamic>{
      'name': instance.name,
      'capacity': instance.capacity,
      'initialEquipmentIds': instance.initialEquipmentIds,
    };
