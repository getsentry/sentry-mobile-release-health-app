

import 'package:flutter/foundation.dart';

import '../../screens/chart/line_chart_point.dart';

class SessionState {
  SessionState({
    required this.projectId,
    required this.numberOfSessions,
    this.previousNumberOfSessions,
    required this.sessionPoints,
    this.previousSessionPoints
  });

  final String projectId;

  final int numberOfSessions;
  final int? previousNumberOfSessions;

  final List<LineChartPoint> sessionPoints;
  final List<LineChartPoint>? previousSessionPoints;
}
