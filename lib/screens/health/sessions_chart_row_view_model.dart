import '../../redux/state/session_state.dart';
import '../../screens/chart/chart_data.dart';
import '../../screens/chart/chart_entry.dart';

class SessionsChartRowViewModel {
  SessionsChartRowViewModel.create(SessionState? sessionState) {
    if (sessionState == null) {
      data = null;
      percentChange = 0.0;
      numberOfIssues = 0;
    } else if (sessionState.sessionPoints.length < 2) {
      data = DataData.prepareData(
          points: [ChartEntry(0, 0), ChartEntry(1, 0)]);
      percentChange = 0.0;
      numberOfIssues = data!.countY.toInt();
    } else {
      data = DataData.prepareData(points: sessionState.sessionPoints);
      final previousNumberOfSessions = sessionState.previousNumberOfSessions;
      if (previousNumberOfSessions != null) {
        percentChange = _percentChange(previousNumberOfSessions.toDouble(),
            sessionState.numberOfSessions.toDouble());
      } else {
        percentChange = 0.0;
      }
      numberOfIssues = data!.countY.toInt();
    }
  }

  DataData? data;
  double? /*late*/ percentChange;
  late int numberOfIssues;

  // Helper

  double _percentChange(double previous, double current) {
    if (previous == 0.0) {
      return 0.0; // Cannot show % increase from previous zero value.
    }
    final increase = current - previous;
    return increase / previous * 100.0;
  }
}
