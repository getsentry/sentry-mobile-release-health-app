// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breadcrumb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Breadcrumb _$BreadcrumbFromJson(Map<String, dynamic> json) {
  return Breadcrumb(
    type: json['type'] as String,
    category: json['category'] as String,
    level: json['level'] as String,
    message: json['message'] as String,
    data: json['data'] as Map<String, dynamic>,
    timestamp: dateTimeFromString(json['timestamp'] as String),
  );
}

Map<String, dynamic> _$BreadcrumbToJson(Breadcrumb instance) =>
    <String, dynamic>{
      'type': instance.type,
      'category': instance.category,
      'level': instance.level,
      'message': instance.message,
      'timestamp': dateTimeToString(instance.timestamp),
      'data': instance.data,
    };
