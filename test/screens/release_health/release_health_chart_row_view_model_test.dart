import 'package:sentry_mobile/screens/chart/line_chart_point.dart';
import 'package:sentry_mobile/screens/release_health/release_health_chart_row_view_model.dart';
import 'package:test/test.dart';

void main() {
  group('createByHalvingPoints', () {
    test('data is trailing', () {

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
        LineChartPoint(2, 0),
        LineChartPoint(3, 5),
      ];

      final sut = ReleaseHealthChartRowViewModel.create(points, []);
      expect(sut.data.points,
        equals([LineChartPoint(0, 0), LineChartPoint(1, 5)]) // x normalized
      );
    });

    test('data is trailing uneven points', () {

      final points = [
        LineChartPoint(0, 1000000),
        LineChartPoint(1, 0),
        LineChartPoint(2, 10),
        LineChartPoint(3, 0),
        LineChartPoint(4, 5),
      ];

      final sut = ReleaseHealthChartRowViewModel.create(points, []);
      expect(sut.data.points,
          equals([LineChartPoint(0, 0), LineChartPoint(1, 5)]) // x normalized
      );
    });

    test('percentChange', () {

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
        LineChartPoint(2, 0),
        LineChartPoint(3, 5),
      ];

      final sut = ReleaseHealthChartRowViewModel.create(points, []);
      expect(sut.percentChange,
          equals(-50.0)
      );
    });

    test('percentChange uneven points', () {

      final points = [
        LineChartPoint(0, 1000000),
        LineChartPoint(1, 0),
        LineChartPoint(2, 10),
        LineChartPoint(3, 0),
        LineChartPoint(4, 5),
      ];

      final sut = ReleaseHealthChartRowViewModel.create(points, []);
      expect(sut.percentChange,
          equals(-50.0)
      );
    });

    test('numberOfIssues', () {

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
        LineChartPoint(2, 0),
        LineChartPoint(3, 5),
      ];

      final sut = ReleaseHealthChartRowViewModel.create(points, []);
      expect(sut.numberOfIssues,
          equals(5)
      );
    });

    test('parentPoints yMax value', () {

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
        LineChartPoint(2, 0),
        LineChartPoint(3, 5),
      ];

      final parentPoints = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 1000)
      ];

      final sut = ReleaseHealthChartRowViewModel.create(points, parentPoints);
      expect(sut.data.maxY,
          equals(1000)
      );
    });
  });
}