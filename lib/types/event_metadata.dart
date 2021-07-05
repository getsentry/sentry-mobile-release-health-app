import 'package:json_annotation/json_annotation.dart';

part 'event_metadata.g.dart';

@JsonSerializable()
class EventMetadata {
  EventMetadata({this.value, this.message, this.type, this.title});

  factory EventMetadata.fromJson(Map<String, dynamic> json) =>
      _$EventMetadataFromJson(json);

  final String? value;
  final String? message;
  final String? type;
  final String? title;

  Map<String, dynamic> toJson() => _$EventMetadataToJson(this);
}

EventMetadata? metadataFromJson(Map<String, dynamic> json) =>
    EventMetadata.fromJson(json);

Map<String, dynamic> metadataToJson(EventMetadata? metadata) =>
    metadata?.toJson() ?? <String, dynamic>{};
