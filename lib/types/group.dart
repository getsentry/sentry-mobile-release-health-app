import 'package:json_annotation/json_annotation.dart';

import '../types/stats.dart';
import '../utils/conversion.dart';
import 'event_metadata.dart';
import 'release.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  Group(
      {this.id,
      this.culprit,
      this.lastSeen,
      this.firstSeen,
      this.userCount,
      this.count,
      this.title,
      this.type,
      this.metadata,
      this.firstRelease,
      this.lastRelease,
      this.stats
      });
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  final String id;
  final String culprit;
  final int userCount;
  final String count;
  final String title;
  final String type;

  @JsonKey(fromJson: dateTimeFromString, toJson: dateTimeToString)
  final DateTime lastSeen;
  @JsonKey(fromJson: dateTimeFromString, toJson: dateTimeToString)
  final DateTime firstSeen;
  @JsonKey(fromJson: _releaseFromJson, toJson: _releaseToJson)
  final Release firstRelease;
  @JsonKey(fromJson: _releaseFromJson, toJson: _releaseToJson)
  final Release lastRelease;

  @JsonKey(fromJson: metadataFromJson, toJson: metadataToJson)
  final EventMetadata metadata;

  final Stats stats;
}

Release _releaseFromJson(Map<String, dynamic> json) =>
    json == null ? null : Release.fromJson(json);
Release _releaseToJson(Release release) => null; //  not used.
