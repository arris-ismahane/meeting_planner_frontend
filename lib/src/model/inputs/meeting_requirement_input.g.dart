// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_requirement_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingRequirementInput _$MeetingRequirementInputFromJson(
        Map<String, dynamic> json) =>
    MeetingRequirementInput(
      type: $enumDecode(_$MeetingTypeEnumMap, json['type']),
      requiredEquipementIds: (json['requiredEquipementIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MeetingRequirementInputToJson(
        MeetingRequirementInput instance) =>
    <String, dynamic>{
      'requiredEquipementIds': instance.requiredEquipementIds,
      'type': _$MeetingTypeEnumMap[instance.type]!,
    };

const _$MeetingTypeEnumMap = {
  MeetingType.VC: 'VC',
  MeetingType.RC: 'RC',
  MeetingType.RS: 'RS',
  MeetingType.SPEC: 'SPEC',
};
