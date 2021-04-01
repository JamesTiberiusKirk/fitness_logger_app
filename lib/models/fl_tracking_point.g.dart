// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_tracking_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlTrackingPoint _$FlTrackingPointFromJson(Map<String, dynamic> json) {
  return FlTrackingPoint(
    tpId: json['_id'] as String?,
    userId: json['userId'] as String?,
    tpTypeId: json['tpTypeId'] as String?,
    tgId: json['tgId'] as String?,
    notes: json['notes'] as String?,
    tpNr: json['tpNr'] as int?,
    data: json['data'],
  );
}

Map<String, dynamic> _$FlTrackingPointToJson(FlTrackingPoint instance) =>
    <String, dynamic>{
      '_id': instance.tpId,
      'userId': instance.userId,
      'tpTypeId': instance.tpTypeId,
      'tgId': instance.tgId,
      'notes': instance.notes,
      'tpNr': instance.tpNr,
      'data': instance.data,
    };

SingleValue _$SingleValueFromJson(Map<String, dynamic> json) {
  return SingleValue(
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$SingleValueToJson(SingleValue instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

Set _$SetFromJson(Map<String, dynamic> json) {
  return Set(
    reps: json['reps'] as String,
    value: json['value'] as String,
    isDropset: json['isDropset'] as String,
    setNr: json['setNr'] as int,
  );
}

Map<String, dynamic> _$SetToJson(Set instance) => <String, dynamic>{
      'reps': instance.reps,
      'value': instance.value,
      'isDropset': instance.isDropset,
      'setNr': instance.setNr,
    };
