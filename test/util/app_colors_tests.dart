import 'package:test/test.dart';

import 'package:sentry_mobile/util/app_colors.dart';

void main() {
  group('colorForPercentage', () {
    test('colorForPercentage.color(1.0) returns dark green color', () {
      expect(AppColors.colorForPercentage(1.0), equals(AppColors.darkGreen));
    });

    test('colorForPercentage.color(0.99) returns dark green color', () {
      expect(AppColors.colorForPercentage(1.0), equals(AppColors.darkGreen));
    });

    test('colorForPercentage.color(0.989) returns green color', () {
      expect(AppColors.colorForPercentage(0.98), equals(AppColors.green));
    });

    test('colorForPercentage.color(0.98) returns green color', () {
      expect(AppColors.colorForPercentage(0.98), equals(AppColors.green));
    });

    test('colorForPercentage.color(0.979) returns yellow color', () {
      expect(AppColors.colorForPercentage(0.979), equals(AppColors.orange));
    });

    test('colorForPercentage.color(0.95) returns yellow color', () {
      expect(AppColors.colorForPercentage(0.95), equals(AppColors.orange));
    });

    test('colorForPercentage.color(0.949) returns red color', () {
      expect(AppColors.colorForPercentage(0.949), equals(AppColors.red));
    });

    test('colorForPercentage.color(0.0) returns red color', () {
      expect(AppColors.colorForPercentage(0.0), equals(AppColors.red));
    });
  });
}