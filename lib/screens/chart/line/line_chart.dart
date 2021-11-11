import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../chart_data.dart';
import '../chart_entry.dart';
import 'line_chart_options.dart';

class LineChart extends StatelessWidget {
  const LineChart(this.data, {required this.options});

  final ChartData? data;
  final LineChartOptions options;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter.create(data, options),
      child: Center(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter.create(this.data, this.options) {
    linePaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = options.lineWidth
      ..color = options.lineColor;
    linePadding = options.lineWidth / 2.0;
  }

  final ChartData? data;
  final LineChartOptions options;

  late Paint linePaint;
  late double linePadding;

  @override
  void paint(Canvas canvas, Size size) {
    final data = this.data;
    if (data == null) {
      return;
    }
    if (data.entries.length < 2) {
      return;
    }

    final screenSize = Size(size.width, size.height - linePadding * 2);

    final screenCoordinateX = (double x) {
      return _normalized(x, data.minX, data.maxX) * screenSize.width;
    };

    final screenCoordinateY = (double y) {
      return _normalized(y, data.minY, data.maxY) * screenSize.height;
    };

    final flipY = (double y) {
      return (size.height - linePadding) - y;
    };

    final pointsWithoutFirst =
        data.entries.map((point) => ChartEntry(point.x, point.y)).toList();
    final firstPoint = pointsWithoutFirst.removeAt(0);
    var previous = ChartEntry(
        screenCoordinateX(firstPoint.x), screenCoordinateY(firstPoint.y));

    // Line

    final linePath = Path();
    linePath.moveTo(previous.x, flipY(previous.y));

    final updateLinePath = (int index, ChartEntry point) {
      final x1 = previous.x;
      final y1 = previous.y;

      final x2 = screenCoordinateX(point.x);
      final y2 = screenCoordinateY(point.y);

      final cx1 = (x1 + x2) / 2;
      final cy1 = y1;

      final cx2 = (x1 + x2) / 2;
      final cy2 = y2;

      if (y1 == y2 || !options.cubicLines) {
        linePath.lineTo(x2, flipY(y2));
      } else {
        linePath.cubicTo(cx1, flipY(cy1), cx2, flipY(cy2), x2, flipY(y2));
      }
      previous = ChartEntry(x2, y2);
    };
    pointsWithoutFirst.asMap().forEach(updateLinePath);

    // Draw

    final gradientStart = options.gradientStart;
    final gradientEnd = options.gradientEnd;
    if (gradientStart != null && gradientEnd != null) {
      final gradientPaint =
      _createGradientPaint(size, gradientStart, gradientEnd);
      final gradientPath = _createGradientPath(linePath, size, firstPoint);
      canvas.drawPath(gradientPath, gradientPaint);
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final oldLineChartPainter = oldDelegate as _LineChartPainter;
    return oldLineChartPainter.data?.entries != data?.entries;
  }

  // Helper

  Paint _createGradientPaint(
      Size size, Color gradientStart, Color gradientEnd) {
    return Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [gradientStart, gradientEnd],
      )
      ..style = PaintingStyle.fill;
  }

  Path _createGradientPath(
      Path linePath, Size size, ChartEntry firstPoint) {
    final gradientPath = Path.from(linePath);
    gradientPath.lineTo(size.width, size.height);
    gradientPath.lineTo(0, size.height);
    gradientPath.lineTo(0, firstPoint.y);
    return gradientPath;
  }

  double _normalized(double point, double min, double max) {
    if ((max - min) == 0) {
      return 0;
    }
    return (point - min) / (max - min);
  }
}
