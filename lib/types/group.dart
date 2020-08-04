
class Group {
  final String id;
  final String culprit;
  final String lastSeen;
  final String userCount;
  final String count;
  final String title;

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        culprit = json['culprit'] as String,
        lastSeen = json['lastSeen'] as String,
        userCount = json['userCount'] as String,
        count = json['count'] as String,
        title = json['title'] as String;
}