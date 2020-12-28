import 'package:test/test.dart';

import 'package:sentry_mobile/types/stat.dart';
import 'package:sentry_mobile/types/stats.dart';

void main() {
  group('stats aggregate 24h and 14d', () {
    test('24h and 14d', () {
      final statsA = Stats(
        [Stat(0, 1), Stat(1, 1), Stat(2, 0)],
        null
      );
      final statsB = Stats(
          null,
          [Stat(3, 1), Stat(4, 1), Stat(5, 0)]
      );

      final aggregatedStats = Stats.aggregated(
        [statsA, statsB]
      );

      expect(
          aggregatedStats.stats24h.map((e) => [e.timestamp, e.value]),
          equals(statsA.stats24h.map((e) => [e.timestamp, e.value]))
      );
      expect(
          aggregatedStats.stats14d.map((e) => [e.timestamp, e.value]),
          equals(statsB.stats14d.map((e) => [e.timestamp, e.value]))
      );
    });

    test('multiple 24h', () {
      final statsA = Stats(
          [Stat(0, 1), Stat(1, 1), Stat(2, 0)],
          null
      );
      final statsB = Stats(
          [Stat(3, 1), Stat(4, 1), Stat(5, 0)],
          null
      );

      final aggregatedStats = Stats.aggregated(
          [statsA, statsB]
      );

      expect(
          aggregatedStats.stats24h.map((e) => [e.timestamp, e.value]),
          equals([Stat(0, 1), Stat(1, 1), Stat(2, 0), Stat(3, 1), Stat(4, 1), Stat(5, 0)].map((e) => [e.timestamp, e.value]))
      );
    });

    test('multiple sorted by timestamp', () {
      final statsA = Stats(
          [Stat(4, 1), Stat(3, 1), Stat(5, 0)],
          null
      );
      final statsB = Stats(
          [Stat(0, 1), Stat(2, 0), Stat(1, 1)],
          null
      );

      final aggregatedStats = Stats.aggregated(
          [statsA, statsB]
      );

      expect(
          aggregatedStats.stats24h.map((e) => [e.timestamp, e.value]),
          equals([Stat(0, 1), Stat(1, 1), Stat(2, 0), Stat(3, 1), Stat(4, 1), Stat(5, 0)].map((e) => [e.timestamp, e.value]))
      );
    });

    test('multiple values with same timestamp added', () {
      final statsA = Stats(
          [Stat(0, 1)],
          null
      );
      final statsB = Stats(
          [Stat(0, 2)],
          null
      );
      final statsC = Stats(
          [Stat(0, 4)],
          null
      );

      final aggregatedStats = Stats.aggregated(
          [statsA, statsB, statsC]
      );

      expect(
          aggregatedStats.stats24h.map((e) => [e.timestamp, e.value]),
          equals([Stat(0, 7)].map((e) => [e.timestamp, e.value]))
      );
    });
  });
}
