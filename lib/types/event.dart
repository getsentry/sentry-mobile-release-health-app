import './event_metadata.dart';

class Tag {
  Tag.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String,
        value = json['value'] as String;

  final String value;
  final String key;
}

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

class Event {
  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        culprit = json['culprit'] as String,
        userCount = json['userCount'] as int,
        count = json['count'] as int,
        title = json['title'] as String,
        metadata =
            EventMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        tags = (json['tags'] as List<dynamic>)
            .map((dynamic t) => Tag.fromJson(t as Map<String, dynamic>))
            .toList(),
        // entries = (json['tags'] as List<dynamic>)
        //     .map((dynamic e) => Entry.fromJson(e as Map<String, dynamic>))
        //     .toList(),
        groupID = json['groupID'] as String;

  final String id;
  final String culprit;
  final int userCount;
  final int count;
  final String title;
  final EventMetadata metadata;
  final List<Tag> tags;
  // final List<Entry> entries;
  final String groupID;
}
