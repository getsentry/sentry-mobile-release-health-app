import 'dart:ui';

class AppColors {
  static const darkGreen = Color(0x7a23B480);
  static const green = Color(0xf723B480);
  static const orange = Color(0xffF3B584);
  static const red = Color(0xffD74177);

  static Color colorForPercentage(double percentage) {
    if (percentage >= 0.99) {
      return darkGreen;
    } else if (percentage >= 0.98) {
      return green;
    } else if (percentage >= 0.95) {
      return orange;
    } else {
      return red;
    }
  }
}

