// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_tracking_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlGroup _$FlGroupFromJson(Map<String, dynamic> json) {
  return FlGroup(
    tgId: json['tgId'] as String?,
    startTime: json['startTime'] as int,
    endTime: json['endTime'] as int?,
    notes: json['notes'] as String?,
  );
}

Map<String, dynamic> _$FlGroupToJson(FlGroup instance) => <String, dynamic>{
      'tgId': instance.tgId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'notes': instance.notes,
    };
