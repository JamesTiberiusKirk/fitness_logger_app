import 'package:json_annotation/json_annotation.dart';
part 'misc_resp.g.dart';

@JsonSerializable()
class LoginResp {
  @JsonKey(name: 'mesage')
  String message;
  @JsonKey(name: 'jwt')
  String jwt;

  LoginResp(this.jwt, this.message);


  factory LoginResp.fromJson(Map<String, dynamic> json) => _$LoginRespFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRespToJson(this);
}
