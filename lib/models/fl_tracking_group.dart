import 'package:json_annotation/json_annotation.dart';

part 'fl_tracking_group.g.dart';


@JsonSerializable()
class FlGroup {

  @JsonKey(name: 'tgId')
  String? tgId;

  @JsonKey(name: 'startTime')
  int startTime;

  @JsonKey(name: 'endTime')
  int? endTime;

  @JsonKey(name: 'notes')
  String? notes;

  FlGroup({
    this.tgId,
    required this.startTime,
    this.endTime,
    this.notes
  });

  factory FlGroup.fromJson(Map<String, dynamic> json) => _$FlGroupFromJson(json);

  Map<String,dynamic> toJson() => _$FlGroupToJson(this);
}
