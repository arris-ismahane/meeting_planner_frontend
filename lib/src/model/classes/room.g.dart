// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      (json['id'] as num).toInt(),
      (json['creationDate'] as num).toInt(),
      (json['lastUpdate'] as num).toInt(),
      initialEquipments: (json['initialEquipments'] as List<dynamic>)
          .map((e) => Equipement.fromJson(e as Map<String, dynamic>))
          .toList(),
      capacity: (json['capacity'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'initialEquipments': instance.initialEquipments,
      'capacity': instance.capacity,
      'name': instance.name,
    };
