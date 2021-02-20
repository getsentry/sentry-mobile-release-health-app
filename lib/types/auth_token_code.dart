import 'package:json_annotation/json_annotation.dart';

part 'auth_token_code.g.dart';

@JsonSerializable()
class AuthTokenCode {
  AuthTokenCode(this.authToken);

  factory AuthTokenCode.fromJson(Map<String, dynamic> json) =>
       _$AuthTokenCodeFromJson(json);

  final String authToken;

  Map<String, dynamic> toJson() => _$AuthTokenCodeToJson(this);
}
