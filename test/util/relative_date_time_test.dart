
import 'package:test/test.dart';

import 'package:sentry_mobile/utils/relative_date_time.dart';

// Source: https://github.com/moment/moment/blob/f5233ee5d44ba20079cd4b389262719bb20e23bd/src/test/moment/relative_time.js
void main() {
  group('relativeFromNow', () {

    test('Seconds to minutes threshold', () {
      var a = DateTime.now();

      a = a.subtract(Duration(seconds: 44));
      expect(
          a.relativeFromNow(),
          equals('a few seconds ago'),
          reason: 'Below default seconds to minutes threshold'
      );

      a = a.subtract(Duration(seconds: 1));
      expect(
          a.relativeFromNow(),
          equals('a minute ago'),
          reason: 'Above default seconds to minutes threshold'
      );
    });

    test('Minutes to hours threshold', () {
      var a = DateTime.now();

      a = a.subtract(Duration(minutes: 44));
      expect(
          a.relativeFromNow(),
          equals('44 minutes ago'),
          reason: 'Below default minute to hour threshold'
      );

      a = a.subtract(Duration(minutes: 1));
      expect(
          a.relativeFromNow(),
          equals('an hour ago'),
          reason: 'Above default minute to hour threshold'
      );
    });

    test('Hours to days threshold', () {
      var a = DateTime.now();

      a = a.subtract(Duration(hours: 21));
      expect(
          a.relativeFromNow(),
          equals('21 hours ago'),
          reason: 'Below default hours to day threshold'
      );

      a = a.subtract(Duration(hours: 1));
      expect(
          a.relativeFromNow(),
          equals('a day ago'),
          reason: 'Above default hours to day threshold'
      );
    });

    test('Days to month threshold', () {
      var a = DateTime.now();

      a = a.subtract(Duration(days: 25));
      expect(
          a.relativeFromNow(),
          equals('25 days ago'),
          reason: 'Below default days to month (singular) threshold'
      );

      a = a.subtract(Duration(days: 1));
      expect(
          a.relativeFromNow(),
          equals('a month ago'),
          reason: 'Above default days to month (singular) threshold'
      );
    });

    test('months to year threshold', () {
      var a = DateTime.now();
      
      a = DateTime(a.year, a.month - 10, a.day, a.hour, a.minute, a.second, a.millisecond, a.microsecond);
      expect(
          a.relativeFromNow(),
          equals('10 months ago'),
          reason: 'Below default days to years threshold'
      );

      a = DateTime(a.year, a.month - 1, a.day, a.hour, a.minute, a.second, a.millisecond, a.microsecond);
      expect(
          a.relativeFromNow(),
          equals('a year ago'),
          reason: 'Above default days to years threshold'
      );
    });

    test('years', () {
      var a = DateTime.now();

      a = DateTime(a.year - 1, a.month, a.day, a.hour, a.minute, a.second, a.millisecond, a.microsecond);
      expect(
          a.relativeFromNow(),
          equals('a year ago')
      );

      a = DateTime(a.year - 1, a.month, a.day, a.hour, a.minute, a.second, a.millisecond, a.microsecond);
      expect(
          a.relativeFromNow(),
          equals('2 years ago')
      );

      a = DateTime(a.year - 10, a.month - 1, a.day, a.hour, a.minute, a.second, a.millisecond, a.microsecond);
      expect(
          a.relativeFromNow(),
          equals('12 years ago')
      );
    });
  });

  group('differenceInYears', () {
    test('same day year after', () {
      final a = DateTime(2019, 01, 01);
      final b = DateTime(2020, 01, 01);
      expect(a.differenceInYears(b), equals(1));
    });

    test('same day year before', () {
      final a = DateTime(2020, 01, 01);
      final b = DateTime(2019, 01, 01);
      expect(a.differenceInYears(b), equals(-1));
    });

    test('same day 10 years after', () {
      final a = DateTime(2010, 01, 01);
      final b = DateTime(2020, 01, 01);
      expect(a.differenceInYears(b), equals(10));
    });

    test('same day 10 years before', () {
      final a = DateTime(2020, 01, 01);
      final b = DateTime(2010, 01, 01);
      expect(a.differenceInYears(b), equals(-10));
    });

    test('not a full year - same month previous year but day short of full year', () {
      final a = DateTime(2020, 01, 01);
      final b = DateTime(2019, 01, 10);
      expect(a.differenceInYears(b), equals(0));
    });

    test('not a full year - same month next year but day short of full year', () {
      final a = DateTime(2019, 01, 02);
      final b = DateTime(2020, 01, 01);
      expect(a.differenceInYears(b), equals(0));
    });

    test('not a full year - previous year short a month', () {
      final a = DateTime(2020, 01, 01);
      final b = DateTime(2019, 02, 01);
      expect(a.differenceInYears(b), equals(0));
    });

    test('not a full year - next year short a month', () {
      final a = DateTime(2019, 02, 01);
      final b = DateTime(2020, 01, 01);
      expect(a.differenceInYears(b), equals(0));
    });
  });
}
