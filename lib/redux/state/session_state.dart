// @dart=2.9

import 'package:flutter/foundation.dart';

import '../../screens/chart/line_chart_point.dart';

class SessionState {
  SessionState({
    @required this.projectId,
    @required this.numberOfSessions,
    @required this.previousNumberOfSessions,
    @required this.sessionPoints,
    @required this.previousSessionPoints
  });

  final String projectId;

  final int numberOfSessions;
  final int previousNumberOfSessions;

  final List<LineChartPoint> sessionPoints;
  final List<LineChartPoint> previousSessionPoints;
}
