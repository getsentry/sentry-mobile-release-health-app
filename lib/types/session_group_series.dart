
import 'package:json_annotation/json_annotation.dart';

import 'session_group.dart';

part 'session_group_series.g.dart';

@JsonSerializable()
class SessionGroupSeries {
  SessionGroupSeries(this.sumSession);
  factory SessionGroupSeries.fromJson(Map<String, dynamic> json) => _$SessionGroupSeriesFromJson(json);

  @JsonKey(name: SessionGroup.sumSessionKey)
  final List<int> sumSession;

  Map<String, dynamic> toJson() => _$SessionGroupSeriesToJson(this);
}
