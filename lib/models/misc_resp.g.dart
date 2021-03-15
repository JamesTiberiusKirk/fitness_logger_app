// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) {
  return LoginResp(
    json['jwt'] as String,
    json['mesage'] as String,
  );
}

Map<String, dynamic> _$LoginRespToJson(LoginResp instance) => <String, dynamic>{
      'mesage': instance.message,
      'jwt': instance.jwt,
    };
