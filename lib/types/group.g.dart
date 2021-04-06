// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    id: json['id'] as String?,
    culprit: json['culprit'] as String?,
    lastSeen: dateTimeFromString(json['lastSeen'] as String),
    firstSeen: dateTimeFromString(json['firstSeen'] as String),
    userCount: json['userCount'] as int?,
    count: json['count'] as String?,
    title: json['title'] as String?,
    type: json['type'] as String?,
    metadata: metadataFromJson(json['metadata'] as Map<String, dynamic>),
    firstRelease:
        _releaseFromJson(json['firstRelease'] as Map<String, dynamic>),
    lastRelease: _releaseFromJson(json['lastRelease'] as Map<String, dynamic>),
    stats: json['stats'] == null
        ? null
        : Stats.fromJson(json['stats'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'culprit': instance.culprit,
      'userCount': instance.userCount,
      'count': instance.count,
      'title': instance.title,
      'type': instance.type,
      'lastSeen': dateTimeToString(instance.lastSeen),
      'firstSeen': dateTimeToString(instance.firstSeen),
      'firstRelease': _releaseToJson(instance.firstRelease),
      'lastRelease': _releaseToJson(instance.lastRelease),
      'metadata': metadataToJson(instance.metadata),
      'stats': instance.stats,
    };
