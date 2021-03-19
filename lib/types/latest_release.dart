// @dart=2.9

import 'package:json_annotation/json_annotation.dart';

part 'latest_release.g.dart';

// TODO(denis): Remove once `Release` implements JsonSerializable.
@JsonSerializable()
class LatestRelease {
  LatestRelease(this.version);

  factory LatestRelease.fromJson(Map<String, dynamic> json) => _$LatestReleaseFromJson(json);

  final String version;

  Map<String, dynamic> toJson() => _$LatestReleaseToJson(this);
}