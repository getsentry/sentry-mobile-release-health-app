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
    count: json['count'] as String,
    title: json['title'] as String,
    metadata: metadataFromJson(json['metadata'] as Map<String, dynamic>),
    firstRelease:
        _releaseFromJson(json['firstRelease'] as Map<String, dynamic>),
    lastRelease: _releaseFromJson(json['lastRelease'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'culprit': instance.culprit,
      'userCount': instance.userCount,
      'count': instance.count,
      'title': instance.title,
      'lastSeen': _dateTimeToString(instance.lastSeen),
      'firstSeen': _dateTimeToString(instance.firstSeen),
      'firstRelease': _releaseToJson(instance.firstRelease),
      'lastRelease': _releaseToJson(instance.lastRelease),
      'metadata': metadataToJson(instance.metadata),
    };
