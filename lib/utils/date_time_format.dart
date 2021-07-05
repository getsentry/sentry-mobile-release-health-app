import 'package:intl/intl.dart';

// Source: https://api.flutter.dev/flutter/dart-core/DateTime/toIso8601String.html
extension DateTimeFormat on DateTime {
  String utcDateTime() {
    final utc = toUtc();
    final String y = (utc.year >= -9999 && utc.year <= 9999)
        ? _fourDigits(utc.year)
        : _sixDigits(utc.year);
    final String m = _twoDigits(utc.month);
    final String d = _twoDigits(utc.day);
    final String h = _twoDigits(utc.hour);
    final String min = _twoDigits(utc.minute);
    final String sec = _twoDigits(utc.second);
    return '$y-$m-${d}T$h:$min:$sec';
  }

  String _sixDigits(int value) {
    return NumberFormat('000000').format(value);
  }

  String _fourDigits(int value) {
    return NumberFormat('0000').format(value);
  }

  String _twoDigits(int value) {
    return NumberFormat('00').format(value);
  }
}
