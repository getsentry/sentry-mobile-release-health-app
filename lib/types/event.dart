import './event_metadata.dart';

class Tag {
  Tag.fromJson(Map<String, dynamic> json)
      : key = json['key'] as String,
        value = json['value'] as String;

  final String value;
  final String key;
}

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
            .toList();

  final String id;
  final String culprit;
  final int userCount;
  final int count;
  final String title;
  final EventMetadata metadata;
  final List<Tag> tags;
}
