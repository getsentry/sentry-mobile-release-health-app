

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(this.id, this.username, this.email);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  final String? id;
  final String? username;
  final String? email;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}