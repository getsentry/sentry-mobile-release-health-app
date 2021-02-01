
import 'package:sentry_mobile/redux/state/session_state.dart';

import '../../screens/chart/line_chart_data.dart';
import '../../screens/chart/line_chart_point.dart';

class SessionsChartRowViewModel {

  SessionsChartRowViewModel.create(SessionState sessionState, List<LineChartPoint> parentPoints) {
    if (sessionState == null || sessionState.points == null) {
      data = null;
      percentChange = 0.0;
      numberOfIssues = 0;
    } else if (sessionState.points.length < 2) {
      data = LineChartData.prepareData(
          points: [
            LineChartPoint(0, 0),
            LineChartPoint(1, 0)
          ]
      );
      percentChange = 0.0;
      numberOfIssues = data.countY.toInt();
    } else {

      if (parentPoints != null && parentPoints.isNotEmpty) {
        final parent = LineChartData.prepareData(points: parentPoints);
        data = LineChartData.prepareData(points: sessionState.points, preferredMinY: parent.minY, preferredMaxY: parent.maxY);
      } else {
        data = LineChartData.prepareData(points: sessionState.points);
      }

      if (sessionState.previousSessionCount != null) {
        percentChange = _percentChange(sessionState.previousSessionCount.toDouble(), sessionState.sessionCount.toDouble());
      } else {
        percentChange = 0.0;
      }
      numberOfIssues = data.countY.toInt();
    }
  }
  
  LineChartData data;
  double percentChange;
  int numberOfIssues;

  // Helper

  double _percentChange(double previous, double current) {
    if (previous == 0.0) {
      return 0.0; // Cannot show % increase from previous zero value.
    }
    final increase = current - previous;
    return increase / previous * 100.0;
  }
}
