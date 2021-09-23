import 'package:sentry_mobile/screens/chart/line_chart_data.dart';
import 'package:sentry_mobile/screens/chart/line_chart_point.dart';
import 'package:test/test.dart';

void main() {
  group('prepareData', () {
    test('xMin xMax normalized', () {
      final sut = LineChartData.prepareData(
          points: [LineChartPoint(10, 0), LineChartPoint(12, 0)]);

      expect(sut.minX, equals(0));
      expect(sut.maxX, equals(2));
    });

    test('xMax one point', () {
      final sut = LineChartData.prepareData(points: [LineChartPoint(10, 0)]);

      expect(sut.minY, equals(0));
      expect(sut.maxY, equals(0));
    });

    test('yMin yMax normalized', () {
      final sut = LineChartData.prepareData(
          points: [LineChartPoint(0, 10), LineChartPoint(1, 12)]);

      expect(sut.minY, equals(0));
      expect(sut.maxY, equals(2));
    });

    test('yMax one point', () {
      final sut = LineChartData.prepareData(points: [LineChartPoint(0, 10)]);

      expect(sut.minY, equals(0));
      expect(sut.maxY, equals(0));
    });
  });
}
