import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:sentry_mobile/screens/chart/bar/bar_chart_options.dart';

import '../chart_data.dart';

class BarChart extends StatelessWidget {

  const BarChart(this.chartData, this.options);

  final ChartData chartData;
  final BarChartOptions options;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(this.chartData);

  ChartData chartData;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}