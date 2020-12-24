
import 'package:equatable/equatable.dart';

class LineChartPoint extends Equatable {
  LineChartPoint(this.x, this.y);
  final double x;
  final double y;

  @override
  String toString() {
    return 'LineChartPoint(x: $x, y: $y)';
  }

  // Equatable

  @override
  List<Object> get props => [x, y];
}
