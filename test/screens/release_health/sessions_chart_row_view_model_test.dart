import 'package:sentry_mobile/redux/state/session_state.dart';
import 'package:sentry_mobile/screens/chart/line_chart_point.dart';
import 'package:sentry_mobile/screens/health/sessions_chart_row_view_model.dart';
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
          projectHasSessions: true,
          numberOfSessions: 10,
          previousNumberOfSessions: 5,
          sessionPoints: points,
          previousSessionPoints: pointsBefore);

      final sut = SessionsChartRowViewModel.create(sessionState);
      expect(sut.data!.points,
          equals([LineChartPoint(0, 0), LineChartPoint(1, 10)]));
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
          projectHasSessions: true,
          numberOfSessions: 10,
          previousNumberOfSessions: 5,
          sessionPoints: points,
          previousSessionPoints: pointsBefore);

      final sut = SessionsChartRowViewModel.create(sessionState);
      expect(sut.percentChange, equals(100.0));
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
          projectHasSessions: true,
          numberOfSessions: 8,
          previousNumberOfSessions: 10,
          sessionPoints: points,
          previousSessionPoints: pointsBefore);

      final sut = SessionsChartRowViewModel.create(sessionState);
      expect(sut.percentChange, equals(-20.0));
    });

    test('fallback no points', () {
      final sessionState = SessionState(
          projectId: 'fixture-projectId',
          projectHasSessions: true,
          numberOfSessions: 0,
          previousNumberOfSessions: 0,
          sessionPoints: [],
          previousSessionPoints: []);

      final sut = SessionsChartRowViewModel.create(sessionState);
      expect(sut.data!.points,
          equals([LineChartPoint(0, 0), LineChartPoint(1, 0)]));
    });
  });
}
