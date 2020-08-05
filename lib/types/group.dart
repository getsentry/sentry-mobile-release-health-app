import 'package:json_annotation/json_annotation.dart';

import './event_metadata.dart';

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
      this.metadata});
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  final String id;
  final String culprit;
  @JsonKey(fromJson: _dateTimeFromString, toJson: _dateTimeToString)
  final DateTime lastSeen;
  @JsonKey(fromJson: _dateTimeFromString, toJson: _dateTimeToString)
  final DateTime firstSeen;
  final int userCount;
  final int count;
  final String title;

  @JsonKey(fromJson: metadataFromJson, toJson: metadataToJson)
  final EventMetadata metadata;
}

DateTime _dateTimeFromString(String dateString) => DateTime.parse(dateString);
String _dateTimeToString(DateTime dateTime) => dateTime
    .toIso8601String(); // probably won't be used, but if it ever is do check if this is the right format.
