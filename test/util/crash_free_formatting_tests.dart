import 'package:test/test.dart';

import 'package:sentry_mobile/utils/crash_free_formatting.dart';

void main() {
  group('formattedPercent', () {
    test('0', () {
      expect(0.0.formattedPercent(), equals('0%'));
    });

    test('<1', () {
      expect(0.999.formattedPercent(), equals('<1%'));
      expect(0.001.formattedPercent(), equals('<1%'));
    });

    test('rounded', () {
      expect(97.1.formattedPercent(), equals('97%'));
      expect(97.9.formattedPercent(), equals('98%'));
    });

    test('threshold 98', () {
      expect(98.0.formattedPercent(), equals('98%'));
    });

    test('above threshold 98 one decimal point', () {
      expect(98.1.formattedPercent(), equals('98.1%'));
    });

    test('above threshold 98 two decimal points', () {
      expect(98.12.formattedPercent(), equals('98.12%'));
    });

    test('above threshold 98 three decimal', () {
      expect(98.123.formattedPercent(), equals('98.123%'));
    });

    test('above threshold 99', () {
      expect(99.0.formattedPercent(), equals('99%'));
    });

    test('above threshold 100', () {
      expect(100.0.formattedPercent(), equals('100%'));
    });
  });

  group('formattedPercentChange', () {
    test('>0 && <1', () {
      expect(0.9.formattedPercentChange(), equals('+0.9%'));
      expect(0.99.formattedPercentChange(), equals('+0.99%'));
      expect(0.999.formattedPercentChange(), equals('+0.999%'));
      expect(0.001.formattedPercentChange(), equals('+0.001%'));
    });

    test('>-1 && <0', () {
      expect((-0.9).formattedPercentChange(), equals('-0.9%'));
      expect((-0.99).formattedPercentChange(), equals('-0.99%'));
      expect((-0.999).formattedPercentChange(), equals('-0.999%'));
      expect((-0.001).formattedPercentChange(), equals('-0.001%'));
    });

    test('rounded', () {
      expect(97.1.formattedPercentChange(), equals('+97%'));
      expect(97.9.formattedPercentChange(), equals('+98%'));
      expect(98.12.formattedPercentChange(), equals('+98%'));
      expect(400.12.formattedPercentChange(), equals('+400%'));
      expect(10000.12.formattedPercentChange(), equals('+10000%'));

      expect((-97.1).formattedPercentChange(), equals('-97%'));
      expect((-97.9).formattedPercentChange(), equals('-98%'));
      expect((-98.12).formattedPercentChange(), equals('-98%'));
      expect((-400.12).formattedPercentChange(), equals('-400%'));
      expect((-10000.12).formattedPercentChange(), equals('-10000%'));
    });
  });
}
