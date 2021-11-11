import 'dart:ui';

class BarChartOptions {
  const BarChartOptions({required this.barColor, this.barWidth = 1.0});

  final Color barColor;
  final double barWidth; // Value between 0 and 1
}
