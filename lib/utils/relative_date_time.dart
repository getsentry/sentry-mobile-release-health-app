
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

  // This method average months, which will not work correctly for large date differences.
  int differenceInMonths(DateTime endDate) {
    return endDate.difference(this).inDays ~/ (365.2425 / 12.0);
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
}
