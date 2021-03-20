


import 'dart:math';

extension RelativeDateTime on DateTime {

  static const secondsToMinuteThreshold = 44;
  static const minutesToHourThreshold = 44;
  static const hoursToDayThreshold = 21;
  static const daysToMonthThreshold = 25;
  static const monthsToYearThreshold = 10;

  String relativeFromNow() {
    final now = DateTime.now();
    final difference = now.difference(this);

    // Years

    final years = differenceInYears(now);
    if (years > 0) {
      if (years > 1) {
        return '$years years ago';
      } else {
        return 'a year ago';
      }
    }

    // Months

    final months = differenceInMonths(now);
    if (months > 0) {
      final fromStartOfMonth = DateTime(year, month);
      final toEndOfMonth = DateTime(now.year, now.month);
      final months = fromStartOfMonth.differenceInMonths(toEndOfMonth);

      if (months > monthsToYearThreshold) {
        return 'a year ago';
      } else if (months > 1) {
        return '$months months ago';
      } else {
        return 'a month ago';
      }
    }

    // Days

    final days = difference.inDays;
    if (days > 0) {
      final fromStartOfDay = DateTime(year, month, day);
      final toEndOfDay = DateTime(now.year, now.month, now.day);
      final days = toEndOfDay.difference(fromStartOfDay).inDays;

      if (days > daysToMonthThreshold) {
        return 'a month ago';
      } else if (days > 1) {
        return '$days days ago';
      } else {
        return 'a day ago';
      }
    }

    // Hours

    final hours = difference.inHours;
    if (hours > 0) {
      final fromStartOfHour = DateTime(year, month, day, hour);
      final toEndOfHour = DateTime(now.year, now.month, now.day, now.hour);
      final hours = toEndOfHour.difference(fromStartOfHour).inHours;

      if (hours > hoursToDayThreshold) {
        return 'a day ago';
      } else if (hours > 1) {
        return '$hours hours ago';
      } else {
        return 'an hour ago';
      }
    }

    // Minutes

    final minutes = difference.inMinutes;
    if  (minutes > 0) {
      final fromStartOfMinute = DateTime(year, month, day, hour, minute);
      final toEndOfMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute);
      final minutes = toEndOfMinute.difference(fromStartOfMinute).inMinutes;

      if (minutes > minutesToHourThreshold) {
        return 'an hour ago';
      } else if (minutes > 1) {
        return '$minutes minutes ago';
      } else {
        return 'a minute ago';
      }
    }

    // Seconds

    final seconds = difference.inSeconds;
    if (seconds > secondsToMinuteThreshold) {
      return 'a minute ago';
    } else {
      return 'a few seconds ago';
    }
  }

  // This uses method average month length, which will not work correctly for large date differences.
  int differenceInMonths(DateTime endDate) {

    return _monthDiff(endDate, this).toInt();
  }



  int differenceInYears(DateTime endDate) {
    final startDate = this;
    var years = endDate.year - startDate.year;
    if (startDate.compareTo(endDate) < 0) {
      if (startDate.month == endDate.month && endDate.day < startDate.day || endDate.month < startDate.month) {
        years--;
      }
    } else {
      if (startDate.month == endDate.month && endDate.day > startDate.day || endDate.month > startDate.month) {
        years++;
      }
    }
    return years;
  }

  // Extracted from Jiffy, which in turn is based on moment.js, which we use in
  // the web version. Don't change code formatting to stay comparable with source.
  // Source: https://pub.dev/packages/jiffy

  static const _daysInMonthArray = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  num _monthDiff(DateTime a, DateTime b) {
    final wholeMonthDiff = ((b.year - a.year) * 12) + (b.month - a.month);
    final anchor = _addMonths(a, wholeMonthDiff);
    DateTime anchor2;
    double adjust;

    if (b.millisecondsSinceEpoch - anchor.millisecondsSinceEpoch < 0) {
      anchor2 = _addMonths(a, wholeMonthDiff - 1);
      adjust = (b.millisecondsSinceEpoch - anchor.millisecondsSinceEpoch) /
          (anchor.millisecondsSinceEpoch - anchor2.millisecondsSinceEpoch);
    } else {
      anchor2 = _addMonths(a, wholeMonthDiff + 1);
      adjust = (b.millisecondsSinceEpoch - anchor.millisecondsSinceEpoch) /
          (anchor2.millisecondsSinceEpoch - anchor.millisecondsSinceEpoch);
    }
    return -(wholeMonthDiff + adjust) ?? 0;
  }

  DateTime _addMonths(DateTime from, int months) {
    final r = months % 12;
    final q = (months - r) ~/ 12;
    var newYear = from.year + q;
    var newMonth = from.month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = min(from.day, _daysInMonth(newYear, newMonth));
    if (from.isUtc) {
      return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
          from.second, from.millisecond, from.microsecond);
    } else {
      return DateTime(newYear, newMonth, newDay, from.hour, from.minute,
          from.second, from.millisecond, from.microsecond);
    }
  }

  int _daysInMonth(int year, int month) {
    var result = _daysInMonthArray[month];
    if (month == 2 && _isLeapYear(year)) {
      result++;
    }
    return result;
  }

  bool _isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}
