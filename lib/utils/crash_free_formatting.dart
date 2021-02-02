
import 'package:intl/intl.dart';

extension CrashFreeFormatting on double {

  static final belowThresholdFormatter = NumberFormat('###');
  static final aboveThresholdFormatter = NumberFormat('###.###');

  // The double value is expected to be between 0 and 100
  String formattedPercent({double threshold = 98.0}) {
    if (this > 0.0 && this < 1.0) {
      return '<1%';
    } else if (this <= threshold) {
      return belowThresholdFormatter.format(this) + '%';
    } else {
      return aboveThresholdFormatter.format(this) + '%';
    }
  }
}
