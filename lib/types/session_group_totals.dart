
import 'package:json_annotation/json_annotation.dart';

import 'session_group.dart';

part 'session_group_totals.g.dart';

@JsonSerializable()
class SessionGroupTotals {
  SessionGroupTotals(this.sumSession);
  factory SessionGroupTotals.fromJson(Map<String, dynamic> json) => _$SessionGroupTotalsFromJson(json);

  @JsonKey(name: SessionGroup.sumSessionKey)
  final int sumSession;

  Map<String, dynamic> toJson() => _$SessionGroupTotalsToJson(this);
}
