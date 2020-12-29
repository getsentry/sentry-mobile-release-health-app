import 'package:flutter/material.dart';
import 'line_chart_point.dart';

class LineChartData {
  LineChartData(this.points, this.minX, this.maxX, this.minY, this.maxY, this.countX, this.countY);

  final List<LineChartPoint> points;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  final double countX;
  final double countY;

  /// Normalize data points so they all start at zero. Return min/max values.
  static LineChartData prepareData({@required List<LineChartPoint> points, double preferredMinY, double preferredMaxY}) {
    var minX = double.maxFinite;
    var maxX = 0.0;
    var minY = double.maxFinite;
    var maxY = 0.0;

    var countX = 0.0;
    var countY = 0.0;

    for (final point in points)  {
      if (point.x < minX) {
        minX = point.x;
      }
      if (point.x > maxX) {
        maxX = point.x;
      }
      if (point.y < minY) {
        minY = point.y;
      }
      if (point.y > maxY) {
        maxY = point.y;
      }

      countX += point.x;
      countY += point.y;
    }

    if (preferredMinY != null) {
      minY = preferredMinY;
    }

    if (preferredMaxY != null) {
      maxY = preferredMaxY;
    }

    return LineChartData(
      points.map((point) => LineChartPoint(point.x - minX, point.y - minY)).toList(),
      0,
      maxX - minX,
      0,
      maxY - minY,
      countX,
      countY
    );
  }
}
