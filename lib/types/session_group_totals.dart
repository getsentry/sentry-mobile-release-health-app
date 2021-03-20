


import 'package:json_annotation/json_annotation.dart';

import 'session_group.dart';

part 'session_group_totals.g.dart';

@JsonSerializable()
class SessionGroupTotals {
  SessionGroupTotals(this.sumSession, this.countUniqueUsers);
  factory SessionGroupTotals.fromJson(Map<String, dynamic> json) => _$SessionGroupTotalsFromJson(json);

  @JsonKey(name: SessionGroup.sumSessionKey)
  final int? sumSession;

  @JsonKey(name: SessionGroup.countUniqueUsersKey)
  final int? countUniqueUsers;

  Map<String, dynamic> toJson() => _$SessionGroupTotalsToJson(this);
}
