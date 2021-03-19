// @dart=2.9


import 'package:intl/intl.dart';

extension CrashFreeFormatting on double {

  static final noDecimalPointFormatter = NumberFormat('###');
  static final decimalFormatter = NumberFormat('###.###');

  // The double value is expected to be between 0 and 100
  String formattedPercent({double threshold = 98.0}) {
    if (this > 0.0 && this < 1.0) {
      return '<1%';
    } else if (this <= threshold) {
      return noDecimalPointFormatter.format(this) + '%';
    } else {
      return decimalFormatter.format(this) + '%';
    }
  }

  // Value expected to be absolute percent values: 100% -> 100
  String formattedPercentChange({double threshold = 1.0}) {
    return decimalFormatter.format(abs()) + '%';
  }
}
