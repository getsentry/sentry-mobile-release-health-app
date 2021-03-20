


import 'package:json_annotation/json_annotation.dart';

import 'session_group_by.dart';
import 'session_group_series.dart';
import 'session_group_totals.dart';

part 'session_group.g.dart';

@JsonSerializable()
class SessionGroup {
  SessionGroup(this.by, this.totals, this.series);
  factory SessionGroup.fromJson(Map<String, dynamic> json) => _$SessionGroupFromJson(json);

  static const sumSessionKey = 'sum(session)';
  static const countUniqueUsersKey = 'count_unique(user)';

  final SessionGroupBy? by;
  final SessionGroupTotals? totals;
  final SessionGroupSeries? series;

  Map<String, dynamic> toJson() => _$SessionGroupToJson(this);
}
