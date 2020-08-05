// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as String,
    culprit: json['culprit'] as String,
    lastSeen: _dateTimeFromString(json['lastSeen'] as String),
    firstSeen: _dateTimeFromString(json['firstSeen'] as String),
    userCount: json['userCount'] as int,
    count: json['count'] as int,
    title: json['title'] as String,
    metadata: metadataFromJson(json['metadata'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'culprit': instance.culprit,
      'lastSeen': _dateTimeToString(instance.lastSeen),
      'firstSeen': _dateTimeToString(instance.firstSeen),
      'userCount': instance.userCount,
      'count': instance.count,
      'title': instance.title,
      'metadata': metadataToJson(instance.metadata),
    };
