import 'package:json_annotation/json_annotation.dart';

import './event_metadata.dart';
import './release.dart';

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
      this.metadata,
      this.firstRelease,
      this.lastRelease});
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  final String id;
  final String culprit;
  final int userCount;
  final String count;
  final String title;

  @JsonKey(fromJson: _dateTimeFromString, toJson: _dateTimeToString)
  final DateTime lastSeen;
  @JsonKey(fromJson: _dateTimeFromString, toJson: _dateTimeToString)
  final DateTime firstSeen;
  @JsonKey(fromJson: _releaseFromJson, toJson: _releaseToJson)
  final Release firstRelease;
  @JsonKey(fromJson: _releaseFromJson, toJson: _releaseToJson)
  final Release lastRelease;

  @JsonKey(fromJson: metadataFromJson, toJson: metadataToJson)
  final EventMetadata metadata;
}

DateTime _dateTimeFromString(String dateString) => DateTime.parse(dateString);
String _dateTimeToString(DateTime dateTime) => dateTime
    .toIso8601String(); // probably won't be used, but if it ever is do check if this is the right format.

Release _releaseFromJson(Map<String, dynamic> json) =>
    json == null ? null : Release.fromJson(json);
Release _releaseToJson(Release release) => null; //  not used.
