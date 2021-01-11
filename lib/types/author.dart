import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  Author(this.id, this.name, this.username, this.avatarUrl);

  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);

  final String id;
  final String name;
  final String username;
  final String avatarUrl;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
