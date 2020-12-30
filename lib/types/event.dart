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
      this.groupID,
      this.context,
      this.entries});

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
  final List<Map<String, dynamic>> entries;
  final String groupID;

  @JsonKey(fromJson: _contextFromJson, toJson: _contextToJson)
  final Map<String, dynamic> context;

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

List<Tag> _tagsFromJson(List<dynamic> jsons) => jsons
    .map((dynamic json) => Tag.fromJson(json as Map<String, dynamic>))
    .toList();
List<Map<String, dynamic>> _tagsToJson(List<Tag> tags) =>
    tags.map((Tag tag) => tag.toJson()).toList();

Map<String, dynamic> _contextFromJson(Map<String, dynamic> json) {
  final newMap = <String, dynamic>{};

  json.forEach((String key, dynamic value) {
    if (value is Map) {
      final stringMap = <String, String>{};
      value.forEach((dynamic innerKey, dynamic innerValue) {
        stringMap[innerKey as String] = '$innerValue';
      });

      newMap[key] = stringMap;
    } else {
      newMap[key] = '$value';
    }
  });

  return newMap;
}

Map<String, dynamic> _contextToJson(Map<String, dynamic> context) => context;
