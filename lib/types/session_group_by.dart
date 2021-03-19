// @dart=2.9

import 'package:json_annotation/json_annotation.dart';
import 'session_status.dart';

part 'session_group_by.g.dart';

@JsonSerializable()
class SessionGroupBy {
  SessionGroupBy(this.sessionStatus, this.project);
  factory SessionGroupBy.fromJson(Map<String, dynamic> json) => _$SessionGroupByFromJson(json);

  static const sessionStatusKey = 'session.status';
  static const projectKey = 'project';

  @JsonKey(name: SessionGroupBy.sessionStatusKey)
  final SessionStatus sessionStatus;

  @JsonKey(name: SessionGroupBy.projectKey)
  final int project;

  Map<String, dynamic> toJson() => _$SessionGroupByToJson(this);
}
