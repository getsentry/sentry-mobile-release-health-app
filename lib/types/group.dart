class GroupMetadata {
  GroupMetadata.fromJson(Map<String, dynamic> json)
      : value = json['value'] as String,
        message = json['message'] as String,
        type = json['type'] as String,
        title = json['title'] as String;

  final String value;
  final String message;
  final String type;
  final String title;

  
}

class Group {
  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        culprit = json['culprit'] as String,
        lastSeen = DateTime.parse(json['lastSeen'] as String),
        firstSeen = DateTime.parse(json['firstSeen'] as String),
        userCount = json['userCount'] as int,
        count = json['count'] as int,
        title = json['title'] as String,
        metadata = GroupMetadata.fromJson(json['metadata'] as Map<String, dynamic>);

  final String id;
  final String culprit;
  final DateTime lastSeen;
  final DateTime firstSeen;
  final int userCount;
  final int count;
  final String title;
  final GroupMetadata metadata;
}