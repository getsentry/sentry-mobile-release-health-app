
import '../../screens/chart/line_chart_data.dart';
import '../../screens/chart/line_chart_point.dart';

class ReleaseHealthChartRowViewModel {

  ReleaseHealthChartRowViewModel.createByHalvingPoints(List<LineChartPoint> points, List<LineChartPoint> parentPoints) {
    if (points == null) {
      data = null;
      percentChange = 0.0;
      numberOfIssues = 0;
    } else if (points.length < 2) {
      data = LineChartData.prepareData(
          points: [
            LineChartPoint(0, 0),
            LineChartPoint(1, 0)
          ]
      );
      percentChange = 0.0;
      numberOfIssues = data.countY.toInt();
    } else {
      final middle = (points.length / 2).ceil();
      
      final trailingPoints = points.sublist(middle, points.length);
      final leadingPoints = points.sublist(middle - trailingPoints.length, middle);

      if (parentPoints.isNotEmpty) {
        final parent = LineChartData.prepareData(points: parentPoints);
        data = LineChartData.prepareData(points: trailingPoints, preferredMinY: parent.minY, preferredMaxY: parent.maxY);
      } else {
        data = LineChartData.prepareData(points: trailingPoints);
      }

      final leading = LineChartData.prepareData(points: leadingPoints);
      percentChange = _percentChange(leading.countY, data.countY);
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
