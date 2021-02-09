
import 'package:json_annotation/json_annotation.dart';

import 'session_group.dart';

part 'session_group_series.g.dart';

@JsonSerializable()
class SessionGroupSeries {
  SessionGroupSeries(this.sumSession, this.countUniqueUsers);
  factory SessionGroupSeries.fromJson(Map<String, dynamic> json) => _$SessionGroupSeriesFromJson(json);

  @JsonKey(name: SessionGroup.sumSessionKey)
  final List<int> sumSession;

  @JsonKey(name: SessionGroup.countUniqueUsersKey)
  final List<int> countUniqueUsers;

  Map<String, dynamic> toJson() => _$SessionGroupSeriesToJson(this);
}
