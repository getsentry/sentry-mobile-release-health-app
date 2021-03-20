

import 'package:intl/intl.dart';

extension SessionFormatting on int {

  static final noDecimalPointFormatter = NumberFormat('###');
  static final twoDecimalPointsFormatter = NumberFormat('###.##');
  static final oneDecimalPointFormatter = NumberFormat('###.#');

  String formattedNumberOfSession() {
    if (this < 1000) {
      return noDecimalPointFormatter.format(this);
    } else if (this < 10000) {
      final tenth = this / 10.0;
      final thousandth = tenth.floor() / 100.0;
      return '${twoDecimalPointsFormatter.format(thousandth)}k';
    } else if (this < 100000) {
      final tenth = this / 10.0;
      final hundreth = tenth / 10.0;
      final thousandth = hundreth.floor() / 10.0;
      return '${oneDecimalPointFormatter.format(thousandth)}k';
    } else if (this < 1000000) {
      final thousandth = this / 1000.0;
      return '${noDecimalPointFormatter.format(thousandth)}k';
    } else {
      final million = this / 1000000.0;
      return '${oneDecimalPointFormatter.format(million)}m';
    }
  }
}
