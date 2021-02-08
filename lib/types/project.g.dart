// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
    json['id'] as String,
    json['name'] as String,
    json['slug'] as String,
    json['platform'] as String,
    (json['platforms'] as List)?.map((e) => e as String)?.toList(),
    json['latestRelease'] == null
        ? null
        : LatestRelease.fromJson(json['latestRelease'] as Map<String, dynamic>),
    json['isBookmarked'] as bool,
  );
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'platform': instance.platform,
      'platforms': instance.platforms,
      'latestRelease': instance.latestRelease,
      'isBookmarked': instance.isBookmarked,
    };
