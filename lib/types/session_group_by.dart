import 'package:json_annotation/json_annotation.dart';

part 'session_group_by.g.dart';

@JsonSerializable()
class SessionGroupBy {
  SessionGroupBy(this.sessionStatus);
  factory SessionGroupBy.fromJson(Map<String, dynamic> json) => _$SessionGroupByFromJson(json);

  static const sessionStatusKey = 'session.status';

  @JsonKey(name: SessionGroupBy.sessionStatusKey)
  final String sessionStatus;

  Map<String, dynamic> toJson() => _$SessionGroupByToJson(this);
}
