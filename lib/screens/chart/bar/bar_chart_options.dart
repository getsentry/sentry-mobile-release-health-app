import 'dart:ui';

class BarChartOptions {
  const BarChartOptions(this.color, {this.width = 1.0});

  final Color color;
  final double width; // Value between 0 and 1
}
