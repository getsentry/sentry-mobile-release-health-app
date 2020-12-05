import 'package:json_annotation/json_annotation.dart';

import 'latest_release.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  Project(this.id, this.name, this.slug, this.platforms, this.latestRelease);
  
  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  final String id;
  final String name;
  final String slug;
  final List<String> platforms;
  final LatestRelease latestRelease; // TODO(denis): Change to `Release` once it implements JsonSerializable.

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

