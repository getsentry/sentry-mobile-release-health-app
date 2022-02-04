import '../../screens/chart/line_chart_point.dart';

class SessionState {
  SessionState(
      {required this.projectId,
      required this.projectHasSessions,
      required this.numberOfSessions,
      this.previousNumberOfSessions,
      required this.sessionPoints,
      this.previousSessionPoints});

  final String projectId;
  final bool projectHasSessions;

  final int numberOfSessions;
  final int? previousNumberOfSessions;

  final List<LineChartPoint> sessionPoints;
  final List<LineChartPoint>? previousSessionPoints;
}
