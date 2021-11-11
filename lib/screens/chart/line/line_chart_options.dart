import 'dart:ui';

import 'package:flutter/material.dart';

class LineChartOptions {
  const LineChartOptions(
      {
    required this.lineWidth,
        required this.lineColor,

      this.cubicLines = false,
      this.gradientStart,
      this.gradientEnd
    }
  );

  final double lineWidth;
  final Color lineColor;

  final bool cubicLines;
  final Color? gradientStart;
  final Color? gradientEnd;

  void test() {
    LineChartOptions(
      lineWidth: 5.0,
      lineColor: Colors.black.withOpacity(0.05)
    );
  }
}