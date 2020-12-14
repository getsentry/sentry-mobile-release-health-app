import 'line_chart_point.dart';

class LineChartData {
  LineChartData(this.points, this.minX, this.maxX, this.minY, this.maxY);
  List<LineChartPoint> points;
  double minX;
  double maxX;
  double minY;
  double maxY;
}
