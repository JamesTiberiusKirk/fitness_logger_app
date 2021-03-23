import 'package:json_annotation/json_annotation.dart';

part 'fl_type.g.dart';

@JsonSerializable()
class FlType {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'userId')
  String? userId;

  @JsonKey(name: 'tpName')
  String? tpName;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'dataType')
  String? dataType;

  @JsonKey(name: 'measurementUnit')
  String? measurmentUnit;

  FlType({
    this.id,
    this.userId,
    this.tpName,
    this.description,
    this.dataType,
    this.measurmentUnit
  });

  factory FlType.fromJson(Map<String, dynamic> json) => _$FlTypeFromJson(json);

  Map<String, dynamic> toJson() => _$FlTypeToJson(this);
}
