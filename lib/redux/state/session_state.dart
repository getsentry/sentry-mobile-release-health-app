import '../../screens/chart/chart_entry.dart';

class SessionState {
  SessionState(
      {required this.projectId,
      required this.numberOfSessions,
      this.previousNumberOfSessions,
      required this.sessionPoints,
      this.previousSessionPoints});

  final String projectId;

  final int numberOfSessions;
  final int? previousNumberOfSessions;

  final List<ChartEntry> sessionPoints;
  final List<ChartEntry>? previousSessionPoints;
}
