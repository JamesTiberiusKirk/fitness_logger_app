// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlType _$FlTypeFromJson(Map<String, dynamic> json) {
  return FlType(
    id: json['_id'] as String?,
    userId: json['userId'] as String?,
    tpName: json['tpName'] as String?,
    description: json['description'] as String?,
    dataType: json['dataType'] as String?,
    measurmentUnit: json['measurementUnit'] as String?,
  );
}

Map<String, dynamic> _$FlTypeToJson(FlType instance) => <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'tpName': instance.tpName,
      'description': instance.description,
      'dataType': instance.dataType,
      'measurementUnit': instance.measurmentUnit,
    };
