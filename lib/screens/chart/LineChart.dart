import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  LineChart(this.points, this.lineWidth, this.lineColor, this.gradientColor);

  final List<Point> points;
  final double lineWidth;
  final Color lineColor;
  final Color gradientColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter.create(points, lineWidth, lineColor, gradientColor),
      child: Center(),
    );
  }
}

class LineChartPainter extends CustomPainter {
  LineChartPainter.create(this.points, double lineWidth, Color lineColor, this.gradientColor) {
    linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..color = lineColor;
  }

  List<Point> points;
  Paint linePaint;
  Color gradientColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Fill
    final gradientPaint = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [gradientColor, Colors.transparent],
      )
      ..style = PaintingStyle.fill;

    final linePath = Path();
    linePath.moveTo(0, size.height);

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

    final paddingBottom = 4.0;
    final paddingTop = 4.0;
    final pointsWithoutFirst = points.map((point) => Point(point.x, point.y)).toList();

    final flippedY = (double y) {
      return flipped(y, size.height, paddingBottom);
    };

    final firstPoint = pointsWithoutFirst.removeAt(0);
    var previous = Point(0, firstPoint.y);
    linePath.moveTo(previous.x, flippedY(previous.y));
    final cubicTo = (int index, Point point) {
      final x1 = previous.x;
      final y1 = previous.y;

      final x2 = normalized((index + 1).toDouble(), 0, points.length.toDouble() - 1) * size.width;
      final y2 = normalized(point.y, minY, maxY) * (size.height - paddingBottom - paddingTop);

      final cx1 = (x1 + x2) / 2;
      final cy1 = y1;

      final cx2 = (x1 + x2) / 2;
      final cy2 = y2;

      if (y1 == y2) {
        linePath.lineTo(x2, flippedY(y2));
      } else {
        linePath.cubicTo(
            cx1,
            flippedY(cy1),
            cx2,
            flippedY(cy2),
            x2,
            flippedY(y2)
        );
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

  double normalized(double point, double min, double max) {
    if ((max - min) == 0) {
      return 0;
    }
    return (point - min) / (max - min);
  }

  double flipped(double coordinate, double height, double padding) {
    return height - padding - coordinate;
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