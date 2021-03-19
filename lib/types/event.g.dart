// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=2.9

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as String,
    culprit: json['culprit'] as String,
    userCount: json['userCount'] as int,
    count: json['count'] as int,
    title: json['title'] as String,
    metadata: metadataFromJson(json['metadata'] as Map<String, dynamic>),
    tags: _tagsFromJson(json['tags'] as List),
    groupID: json['groupID'] as String,
    context: _contextFromJson(json['context'] as Map<String, dynamic>),
    entries: (json['entries'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
  );
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'culprit': instance.culprit,
      'userCount': instance.userCount,
      'count': instance.count,
      'title': instance.title,
      'metadata': metadataToJson(instance.metadata),
      'tags': _tagsToJson(instance.tags),
      'entries': instance.entries,
      'groupID': instance.groupID,
      'context': _contextToJson(instance.context),
    };
