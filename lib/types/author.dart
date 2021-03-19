// @dart=2.9

import 'package:json_annotation/json_annotation.dart';

import 'avatar.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  Author(this.id, this.name, this.email, this.avatarUrl, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);

  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final Avatar avatar;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
