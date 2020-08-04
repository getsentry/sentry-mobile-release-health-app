class EventMetadata {
  EventMetadata.fromJson(Map<String, dynamic> json)
      : value = json['value'] as String,
        message = json['message'] as String,
        type = json['type'] as String,
        title = json['title'] as String;

  final String value;
  final String message;
  final String type;
  final String title;
}
