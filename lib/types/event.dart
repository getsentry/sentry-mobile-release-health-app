import 'package:json_annotation/json_annotation.dart';

import './event_metadata.dart';
import './tag.dart';

part 'event.g.dart';

// class Entry {
//   Entry.fromJson(Map<String, dynamic> json)
//       : type = json['type'] as String,
//         data = EntryTypeData.fromJson(json['data'] as Map<String, dynamic>);

//   final String type;
//   final dynamic data;
// }

// class ExceptionEntry extends Entry {
//   @override
//   final String type = 'exception';
// }

// class EntryExceptionRecord {
//   final List<StackFrame> stacktrace;
// }

// class StackFrame {
//   final String function;
//   final int lineNo;
//   final int colNo;
//   final List<[int, String]> context;
// }
@JsonSerializable()
class Event {
  Event(
      {this.id,
      this.culprit,
      this.userCount,
      this.count,
      this.title,
      this.metadata,
      this.tags,
      this.groupID});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  final String id;
  final String culprit;
  final int userCount;
  final int count;
  final String title;

  @JsonKey(fromJson: metadataFromJson, toJson: metadataToJson)
  final EventMetadata metadata;

  @JsonKey(fromJson: _tagsFromJson, toJson: _tagsToJson)
  final List<Tag> tags;

  // final List<Entry> entries;
  final String groupID;

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

List<Tag> _tagsFromJson(List<dynamic> jsons) => jsons
    .map((dynamic json) => Tag.fromJson(json as Map<String, dynamic>))
    .toList();
List<Map<String, dynamic>> _tagsToJson(List<Tag> tags) =>
    tags.map((Tag tag) => tag.toJson()).toList();
