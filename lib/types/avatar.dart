

import 'package:json_annotation/json_annotation.dart';

part 'avatar.g.dart';

@JsonSerializable()
class Avatar {
  Avatar(this.avatarType);

  factory Avatar.fromJson(Map<String, dynamic> json) =>
      _$AvatarFromJson(json);

  final String? avatarType;

  Map<String, dynamic> toJson() => _$AvatarToJson(this);
}
