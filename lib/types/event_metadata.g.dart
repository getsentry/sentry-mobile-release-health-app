// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventMetadata _$EventMetadataFromJson(Map<String, dynamic> json) {
  return EventMetadata(
    value: json['value'] as String?,
    message: json['message'] as String?,
    type: json['type'] as String?,
    title: json['title'] as String?,
  );
}

Map<String, dynamic> _$EventMetadataToJson(EventMetadata instance) =>
    <String, dynamic>{
      'value': instance.value,
      'message': instance.message,
      'type': instance.type,
      'title': instance.title,
    };
