import 'package:sentry_mobile/screens/chart/chart_data.dart';
import 'package:sentry_mobile/screens/chart/chart_entry.dart';
import 'package:test/test.dart';

void main() {
  group('prepareData', () {
    test('xMin xMax normalized', () {
      final sut = ChartData.prepareData(
          points: [ChartEntry(10, 0), ChartEntry(12, 0)]);

      expect(sut.minX, equals(0));
      expect(sut.maxX, equals(2));
    });

    test('xMax one point', () {
      final sut = ChartData.prepareData(points: [ChartEntry(10, 0)]);

      expect(sut.minY, equals(0));
      expect(sut.maxY, equals(0));
    });

    test('yMin yMax normalized', () {
      final sut = ChartData.prepareData(
          points: [ChartEntry(0, 10), ChartEntry(1, 12)]);

      expect(sut.minY, equals(0));
      expect(sut.maxY, equals(2));
    });

    test('yMax one point', () {
      final sut = ChartData.prepareData(points: [ChartEntry(0, 10)]);

      expect(sut.minY, equals(0));
      expect(sut.maxY, equals(0));
    });
  });
}
