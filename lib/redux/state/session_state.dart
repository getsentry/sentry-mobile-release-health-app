import 'package:flutter/foundation.dart';

import '../../screens/chart/line_chart_point.dart';

class SessionState {
  SessionState({
    @required this.projectId,
    @required this.sessionCount,
    @required this.previousSessionCount,
    @required this.points,
    @required this.previousPoints
  });

  final String projectId;

  final int sessionCount;
  final int previousSessionCount;

  final List<LineChartPoint> points;
  final List<LineChartPoint> previousPoints;
}
