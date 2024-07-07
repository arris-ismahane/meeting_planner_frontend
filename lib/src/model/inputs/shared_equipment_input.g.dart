// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_equipment_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedEquipmentInput _$SharedEquipmentInputFromJson(
        Map<String, dynamic> json) =>
    SharedEquipmentInput(
      total: (json['total'] as num).toInt(),
      equipmentId: (json['equipmentId'] as num).toInt(),
    );

Map<String, dynamic> _$SharedEquipmentInputToJson(
        SharedEquipmentInput instance) =>
    <String, dynamic>{
      'equipmentId': instance.equipmentId,
      'total': instance.total,
    };
