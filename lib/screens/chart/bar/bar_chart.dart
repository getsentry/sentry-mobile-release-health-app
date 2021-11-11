import 'dart:ui';

import 'package:flutter/material.dart';

import '../chart_data.dart';
import '../chart_entry.dart';
import 'bar_chart_options.dart';

class BarChart extends StatelessWidget {

  const BarChart(this.data, {required this.options});

  final ChartData data;
  final BarChartOptions options;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter.create(data, options),
      child: Center(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter.create(this.data, this.options) {
    barPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = options.barColor;
  }

  final ChartData data;
  final BarChartOptions options;

  late Paint barPaint;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final screenCoordinateY = (double y) {
      return _normalized(y, data.minY, data.maxY) * size.height;
    };

    final slotWidth = size.width / data.entries.length;
    final barWidth = slotWidth * options.barWidth;

    final drawBar = (int index, ChartEntry entry) {
      final barHeight = screenCoordinateY(entry.y);
      final dx = slotWidth * index + (slotWidth - barWidth) / 2;
      final dy = size.height - barHeight;
      canvas.drawRect(
          Offset(dx, dy) & Size(barWidth, barHeight),
          barPaint
      );
    };
    data.entries.asMap().forEach(drawBar);
  }

  double _normalized(double point, double min, double max) {
    if ((max - min) == 0) {
      return 0;
    }
    return (point - min) / (max - min);
  }
}
