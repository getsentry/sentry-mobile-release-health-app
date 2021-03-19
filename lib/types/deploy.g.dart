// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=2.9

part of 'deploy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deploy _$DeployFromJson(Map<String, dynamic> json) {
  return Deploy(
    json['environment'] as String,
    json['dateFinished'] == null
        ? null
        : DateTime.parse(json['dateFinished'] as String),
  );
}

Map<String, dynamic> _$DeployToJson(Deploy instance) => <String, dynamic>{
      'environment': instance.environment,
      'dateFinished': instance.dateFinished?.toIso8601String(),
    };
