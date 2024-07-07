// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_requirement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRequirement _$MeetingRequirementFromJson(Map<String, dynamic> json) =>
    MeetingRequirement(
      (json['id'] as num).toInt(),
      (json['creationDate'] as num).toInt(),
      (json['lastUpdate'] as num).toInt(),
      requiredEquipements: (json['requiredEquipements'] as List<dynamic>)
          .map((e) => Equipement.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecode(_$MeetingTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$MeetingRequirementToJson(MeetingRequirement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'requiredEquipements': instance.requiredEquipements,
      'type': _$MeetingTypeEnumMap[instance.type]!,
    };

const _$MeetingTypeEnumMap = {
  MeetingType.VC: 'VC',
  MeetingType.RC: 'RC',
  MeetingType.RS: 'RS',
  MeetingType.SPEC: 'SPEC',
};
