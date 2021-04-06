

import 'package:json_annotation/json_annotation.dart';
import 'session_group.dart';

part 'sessions.g.dart';

@JsonSerializable()
class Sessions {
  Sessions(this.intervals, this.groups);
  factory Sessions.fromJson(Map<String, dynamic> json) => _$SessionsFromJson(json);

  final List<DateTime>? intervals;
  final List<SessionGroup>? groups;

  Map<String, dynamic> toJson() => _$SessionsToJson(this);
}
