import 'package:sentry_mobile/redux/state/session_state.dart';
import 'package:sentry_mobile/screens/chart/line_chart_point.dart';
import 'package:sentry_mobile/screens/release_health/release_health_chart_row_view_model.dart';
import 'package:test/test.dart';

void main() {
  group('createByHalvingPoints', () {
    test('data is points', () {

      final pointsBefore = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 5),
      ];

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
      ];

      final sessionState = SessionState(
          projectId: 'fixture-projectId',
          sessionCount: 10,
          previousSessionCount: 5,
          points: points,
          previousPoints: pointsBefore
      );

      final sut = ReleaseHealthChartRowViewModel.create(sessionState, []);
      expect(sut.data.points,
        equals([LineChartPoint(0, 0), LineChartPoint(1, 10)])
      );
    });

    test('percentChange increase', () {
      final pointsBefore = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 5),
      ];

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
      ];

      final sessionState = SessionState(
          projectId: 'fixture-projectId',
          sessionCount: 10,
          previousSessionCount: 5,
          points: points,
          previousPoints: pointsBefore
      );

      final sut = ReleaseHealthChartRowViewModel.create(sessionState, []);
      expect(sut.percentChange,
          equals(100.0)
      );
    });

    test('percentChange decrease', () {
      final pointsBefore = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
      ];

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 8),
      ];

      final sessionState = SessionState(
          projectId: 'fixture-projectId',
          sessionCount: 8,
          previousSessionCount: 10,
          points: points,
          previousPoints: pointsBefore
      );

      final sut = ReleaseHealthChartRowViewModel.create(sessionState, []);
      expect(sut.percentChange,
          equals(-20.0)
      );
    });

    test('parentPoints yMax value', () {
      final pointsBefore = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 5),
      ];

      final points = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 10),
      ];

      final sessionState = SessionState(
          projectId: 'fixture-projectId',
          sessionCount: 10,
          previousSessionCount: 5,
          points: points,
          previousPoints: pointsBefore
      );

      final parentPoints = [
        LineChartPoint(0, 0),
        LineChartPoint(1, 1000)
      ];

      final sut = ReleaseHealthChartRowViewModel.create(sessionState, parentPoints);
      expect(sut.data.maxY,
          equals(1000)
      );
    });

    test('fallback no points', () {
      final sessionState = SessionState(
          projectId: 'fixture-projectId',
          sessionCount: 0,
          previousSessionCount: 0,
          points: [],
          previousPoints: []
      );

      final sut = ReleaseHealthChartRowViewModel.create(sessionState, []);
      expect(sut.data.points,
          equals([LineChartPoint(0, 0), LineChartPoint(1, 0)])
      );
    });
  });
}
