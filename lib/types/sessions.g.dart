// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sessions _$SessionsFromJson(Map<String, dynamic> json) {
  return Sessions(
    (json['intervals'] as List<dynamic>?)
        ?.map((e) => DateTime.parse(e as String))
        .toList(),
    (json['groups'] as List<dynamic>?)
        ?.map((e) => SessionGroup.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SessionsToJson(Sessions instance) => <String, dynamic>{
      'intervals': instance.intervals?.map((e) => e.toIso8601String()).toList(),
      'groups': instance.groups,
    };
