// @dart=2.9

import 'package:json_annotation/json_annotation.dart';

import 'latest_release.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  Project(this.id, this.name, this.slug, this.platform, this.platforms, this.latestRelease, this.isBookmarked);
  
  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  final String id;
  final String name;
  final String slug;
  final String platform;
  final List<String> platforms;
  final LatestRelease latestRelease; // TODO(denis): Change to `Release` once it implements JsonSerializable.
  final bool isBookmarked;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  Project copyWith({
    String id,
    String name,
    String slug,
    String platform,
    List<String> platforms,
    LatestRelease latestRelease,
    bool isBookmarked
  }) {
    return Project(
      id ?? this.id,
      name ?? this.name,
      slug ?? this.slug,
      platform ?? this.platform,
      platforms ?? this.platforms,
      latestRelease ?? this.latestRelease,
      isBookmarked ?? this.isBookmarked
    );
  }
}
