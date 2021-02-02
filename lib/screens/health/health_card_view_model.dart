
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';
import 'package:sentry_mobile/utils/sentry_icons.dart';

class HealthCardViewModel {
  HealthCardViewModel(this.value, this.change);

  HealthCardViewModel.stabilityScore(double value, double valueBefore) {
    color = colorForValue(value);
    if (value != null) {
      this.value = valueFormatPercent.format(value) + '%';
    } else {
      this.value = '--';
    }
    if (value != null && valueBefore != null) {
      final changeValue = value - valueBefore;
      final trendSign = changeValue > 0 ? '+' : '';
      change = trendSign + valueFormatPercent.format(changeValue) + '%';
      trendIcon = getTrendIcon(changeValue);
    } else {
      change = '--';
    }
  }

  HealthCardViewModel.apdex(double value, double valueBefore) {
    color = colorForValue(value != null ? value * 100 : null);
    if (value != null) {
      this.value = valueFormatApdex.format(value);
    } else {
      this.value = '--';
    }
    if (value != null && valueBefore != null && valueBefore != 0.0) {
      final changeValue = value - valueBefore;
      final trendSign = changeValue > 0 ? '+' : '';
      change = trendSign + valueFormatApdex.format(changeValue);
      trendIcon = getTrendIcon(changeValue);
    } else {
      change = '--';
    }
  }

  static final valueFormatPercent = NumberFormat('###.##');
  static final valueFormatApdex = NumberFormat('#.###');
  static const warningThreshold = 99.5;
  static const dangerThreshold = 98;

  Color color;
  String value;

  String change;
  Icon trendIcon;

  static Color colorForValue(double value) {
    return value == null
      ? SentryColors.lavenderGray
      : value > warningThreshold
        ? SentryColors.shamrock
        : value > dangerThreshold
          ? SentryColors.lightningYellow
          : SentryColors.burntSienna;
  }

  static Icon getTrendIcon(double change) {
    if (change == null || change == 0) {
      return null;
    }
    return change == 0
        ? Icon(SentryIcons.trend_same, color: SentryColors.lavenderGray, size: 8.0)
        : change > 0
          ? Icon(SentryIcons.trend_up, color: SentryColors.shamrock, size: 8.0)
          : Icon(SentryIcons.trend_down, color: SentryColors.burntSienna, size: 8.0);
  }
}
