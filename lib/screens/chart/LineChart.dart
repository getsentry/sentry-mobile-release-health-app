import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  LineChart(this.points, this.lineWidth, this.lineColor, this.gradientStart, this.gradientEnd);

  final List<Point> points;
  final double lineWidth;
  final Color lineColor;
  final Color gradientStart;
  final Color gradientEnd;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter.create(points, lineWidth, lineColor, gradientStart, gradientEnd),
      child: Center(),
    );
  }
}

class LineChartPainter extends CustomPainter {
  LineChartPainter.create(List<Point> points, double lineWidth, Color lineColor, this.gradientStart, this.gradientEnd) {
    data = prepareData(points);
    linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = lineColor;
    linePadding = lineWidth / 2.0;
  }

  Data data;
  Paint linePaint;
  double linePadding;
  Color gradientStart;
  Color gradientEnd;

  @override
  void paint(Canvas canvas, Size size) {
    // Fill
    final gradientPaint = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [gradientStart, gradientEnd],
      )
      ..style = PaintingStyle.fill;

    final screenSize = Size(size.width, size.height - linePadding * 2);

    final screenCoordinateX = (double x) {
      return normalized(x, data.minX, data.maxX) * screenSize.width;
    };

    final screenCoordinateY = (double y) {
      return normalized(y, data.minY, data.maxY) * screenSize.height;
    };

    final flipY = (double y) {
      return (size.height - linePadding) - y;
    };

    final pointsWithoutFirst = data.points.map((point) => Point(point.x, point.y)).toList();
    final firstPoint = pointsWithoutFirst.removeAt(0);
    var previous = Point(
        screenCoordinateX(firstPoint.x), screenCoordinateY(firstPoint.y)
    );

    final linePath = Path();
    linePath.moveTo(
        previous.x, flipY(previous.y)
    );

    final cubicTo = (int index, Point point) {
      final x1 = previous.x;
      final y1 = previous.y;

      final x2 = screenCoordinateX(point.x);
      final y2 = screenCoordinateY(point.y);

      final cx1 = (x1 + x2) / 2;
      final cy1 = y1;

      final cx2 = (x1 + x2) / 2;
      final cy2 = y2;

      if (y1 == y2) {
        linePath.lineTo(x2, flipY(y2));
      } else {
        linePath.cubicTo(cx1, flipY(cy1), cx2, flipY(cy2), x2, flipY(y2));
      }
      previous = Point(x2 , y2);
    };
    pointsWithoutFirst.asMap().forEach(cubicTo);

    final gradientPath = Path.from(linePath);
    gradientPath.lineTo(size.width, size.height);
    gradientPath.lineTo(0, size.height);
    gradientPath.lineTo(0, firstPoint.y);
    canvas.drawPath(gradientPath, gradientPaint);

    canvas.drawPath(linePath, linePaint);
  }

  /// Normalize data points so they all start at zero. Return min/max values.
  Data prepareData(List<Point> points) {
    var minX = double.maxFinite;
    var maxX = 0.0;
    var minY = double.maxFinite;
    var maxY = 0.0;

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
    }
    return Data(
      points.map((point) => Point(point.x - minX, point.y - minY)).toList(),
      0,
      maxX - minX,
      0,
      maxY - minY
    );
  }

  double normalized(double point, double min, double max) {
    if ((max - min) == 0) {
      return 0;
    }
    return (point - min) / (max - min);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Point {
  Point(this.x, this.y);
  final double x;
  final double y;
}

class Data {
  Data(this.points, this.minX, this.maxX, this.minY, this.maxY);
  List<Point> points;
  double minX;
  double maxX;
  double minY;
  double maxY;
}