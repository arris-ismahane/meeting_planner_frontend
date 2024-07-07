// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedEquipment _$SharedEquipmentFromJson(Map<String, dynamic> json) =>
    SharedEquipment(
      (json['id'] as num).toInt(),
      (json['creationDate'] as num).toInt(),
      (json['lastUpdate'] as num).toInt(),
      equipment: Equipement.fromJson(json['equipment'] as Map<String, dynamic>),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$SharedEquipmentToJson(SharedEquipment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'equipment': instance.equipment,
      'total': instance.total,
    };
