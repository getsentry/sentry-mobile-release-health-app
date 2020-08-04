
class Group {
  final String id;
  final String culprit;
  final String lastSeen;
  final int userCount;
  final int count;
  final String title;

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        culprit = json['culprit'] as String,
        lastSeen = json['lastSeen'] as String,
        userCount = json['userCount'] as int,
        count = json['count'] as int,
        title = json['title'] as String;
}