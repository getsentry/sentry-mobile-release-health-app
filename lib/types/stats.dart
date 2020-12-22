import 'package:json_annotation/json_annotation.dart';
import 'package:sentry_mobile/types/stat.dart';

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

  // Helper

  static List<Stat> _aggregateAndSort(List<List<Stat>> allStats) {
    final aggregatedStats = <Stat>[];

    final Function(List<Stat> stats) addAll = (List<Stat> stats) {
      aggregatedStats.addAll(stats);
    };
    allStats.forEach(addAll);

    aggregatedStats.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return aggregatedStats;
  }
}
