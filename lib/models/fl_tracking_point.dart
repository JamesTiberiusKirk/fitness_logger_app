import 'package:json_annotation/json_annotation.dart';

part 'fl_tracking_point.g.dart';

@JsonSerializable()
class FlTrackingPoint {

  @JsonKey(name: '_id')
  String? tpId;

  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'tpTypeId')
  String? tpTypeId;

  @JsonKey(name: 'tgId')
  String? tgId;

  @JsonKey(name: 'notes')
  String? notes;

  @JsonKey(name: 'tpNr')
  int? tpNr;


  @JsonKey(name: 'data')
  dynamic data;
  
  FlTrackingPoint({
    this.tpId,
    this.userId,
    this.tpTypeId,
    this.tgId,
    this.notes,
    this.tpNr,
    required this.data,
  });

  factory FlTrackingPoint.fromJson(Map<String, dynamic> json) => _$FlTrackingPointFromJson(json);

  Map<String, dynamic> toJson() => _$FlTrackingPointToJson(this);

}

@JsonSerializable()
class SingleValue{
  @JsonKey(name: 'value')
  String value;

  SingleValue({required this.value});

  factory SingleValue.fromJson(Map<String, dynamic> json) => _$SingleValueFromJson(json);

  Map<String, dynamic> toJson() => _$SingleValueToJson(this);

}

@JsonSerializable()
class FlSet {
  @JsonKey(name: 'reps')
  String reps;

  @JsonKey(name: 'value')
  String value;

  @JsonKey(name: 'isDropset')
  String isDropset;

  @JsonKey(name: 'setNr')
  int? setNr;

  FlSet({required this.reps, required this.value, required this.isDropset, this.setNr});

  factory FlSet.fromJson(Map<String, dynamic> json) => _$FlSetFromJson(json);

  Map<String, dynamic> toJson() => _$FlSetToJson(this);

}
