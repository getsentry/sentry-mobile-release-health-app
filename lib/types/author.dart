import 'package:json_annotation/json_annotation.dart';
import 'package:sentry_mobile/types/avatar.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  Author(this.id, this.name, this.username, this.avatarUrl, this.avatar);

  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);

  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final Avatar avatar;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
