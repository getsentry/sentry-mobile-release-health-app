import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_mobile/utils/session_formatting.dart';

void main() {
  group('formattedNumberOfSession', () {
    test('below 1000', () {
      expect(0.formattedNumberOfSession(), equals('0'));
      expect(1.formattedNumberOfSession(), equals('1'));
      expect(999.formattedNumberOfSession(), equals('999'));
    });

    test('below 10.000', () {
      expect(1000.formattedNumberOfSession(), equals('1k'));
      expect(1354.formattedNumberOfSession(), equals('1.35k'));
      expect(9999.formattedNumberOfSession(), equals('9.99k'));
    });

    test('below 100k', () {
      expect(10000.formattedNumberOfSession(), equals('10k'));
      expect(12499.formattedNumberOfSession(), equals('12.4k'));
      expect(12500.formattedNumberOfSession(), equals('12.5k'));
    });

    test('100k and above', () {
      expect(100000.formattedNumberOfSession(), equals('100k'));
      expect(100400.formattedNumberOfSession(), equals('100k'));
      expect(100500.formattedNumberOfSession(), equals('101k'));
    });

    test('1m and above', () {
      expect(1000000.formattedNumberOfSession(), equals('1m'));
      expect(1550000.formattedNumberOfSession(), equals('1.6m'));
      expect(10550000.formattedNumberOfSession(), equals('10.6m'));
      expect(900000000.formattedNumberOfSession(), equals('900m'));
    });
  });
}
