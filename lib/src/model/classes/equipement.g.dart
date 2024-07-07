// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipement _$EquipementFromJson(Map<String, dynamic> json) => Equipement(
      (json['id'] as num).toInt(),
      (json['creationDate'] as num).toInt(),
      (json['lastUpdate'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$EquipementToJson(Equipement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'name': instance.name,
    };
