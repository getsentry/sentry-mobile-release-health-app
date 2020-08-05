// GENERATED CODE - DO NOT MODIFY BY HAND

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
      'groupID': instance.groupID,
    };
