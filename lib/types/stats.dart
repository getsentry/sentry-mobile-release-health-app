import 'package:json_annotation/json_annotation.dart';
import 'stat.dart';

part 'stats.g.dart';

@JsonSerializable()
class Stats {
  Stats(this.stats24h, this.stats14d);
  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
  Stats.aggregated(List<Stats> stats)
    : stats24h = Stats._aggregateAndSort(stats.map((e) => e.stats24h ?? []).toList()),
      stats14d = Stats._aggregateAndSort(stats.map((e) => e.stats14d ?? []).toList());

  @JsonKey(name: '24h')
  final List<Stat> stats24h;

  @JsonKey(name: '14d')
  final List<Stat> stats14d;

  Map<String, dynamic> toJson() => _$StatsToJson(this);

  // Helper

  static List<Stat> _aggregateAndSort(List<List<Stat>> allStats) {

    final aggregatedValuesByTimestamp = <int, int>{};

    final Function(List<Stat> stats) addAll = (List<Stat> stats) {
      for (final stat in stats) {
        aggregatedValuesByTimestamp[stat.timestamp] =  stat.value + (aggregatedValuesByTimestamp[stat.timestamp] ?? 0);
      }
    };
    allStats.forEach(addAll);

    final aggregatedStats = aggregatedValuesByTimestamp.keys
      .map((timestamp) => Stat(timestamp, aggregatedValuesByTimestamp[timestamp]))
      .toList();

    aggregatedStats.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return aggregatedStats;
  }
}
