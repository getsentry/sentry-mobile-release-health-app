
extension RelativeDateTime on DateTime {
  String relativeFromNow() {
    final now = DateTime.now();
    final difference = now.difference(this);

    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;
    final months = differenceInMonths(now);
    final years = differenceInYears(now);

    if (years > 0) {
      if (years > 1) {
        return '$years years ago';
      } else {
        return 'a year ago';
      }
    } else if (months > 0) {
      if (months > 10) {
        return 'a year ago';
      } else if (months > 1) {
        return '$months months ago';
      } else {
        return 'a month ago';
      }
    } else if (days > 0) {
      if (days > 25) {
        return 'a month ago';
      } else if (days > 1) {
        return '$days days ago';
      } else {
        return 'a day ago';
      }
    } else if (hours > 0) {
      if (hours > 21) {
        return 'a day ago';
      } else if (hours > 1) {
        return '$hours hours ago';
      } else {
        return 'an hour ago';
      }
    } else if  (minutes > 0) {
      if (minutes > 44) {
        return 'an hour ago';
      } else if (minutes > 1) {
        return '$minutes minutes ago';
      } else {
        return 'a minute ago';
      }
    } else if (seconds > 44) {
      return 'a minute ago';
    }
    return 'a few seconds ago';
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
