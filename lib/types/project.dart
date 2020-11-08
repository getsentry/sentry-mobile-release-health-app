import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  Project(this.id, this.name, this.slug, this.platforms);
  
  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  final String id;
  final String name;
  final String slug;
  final List<String> platforms;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}