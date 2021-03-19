// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=2.9

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) {
  return Organization(
    json['id'] as String,
    json['name'] as String,
    json['slug'] as String,
    json['apdexThreshold'] as int,
  );
}

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'apdexThreshold': instance.apdexThreshold,
    };
