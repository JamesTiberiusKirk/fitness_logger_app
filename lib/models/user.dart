import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'password')
  String password;

  User(this.email, this.password);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserRegistration {
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'password')
  String password;

  UserRegistration(this.email, this.username, this.password);

  factory UserRegistration.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationToJson(this);
}
