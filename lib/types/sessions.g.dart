// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=2.9

part of 'sessions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sessions _$SessionsFromJson(Map<String, dynamic> json) {
  return Sessions(
    (json['intervals'] as List)
        ?.map((e) => e == null ? null : DateTime.parse(e as String))
        ?.toList(),
    (json['groups'] as List)
        ?.map((e) =>
            e == null ? null : SessionGroup.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SessionsToJson(Sessions instance) => <String, dynamic>{
      'intervals':
          instance.intervals?.map((e) => e?.toIso8601String())?.toList(),
      'groups': instance.groups,
    };
