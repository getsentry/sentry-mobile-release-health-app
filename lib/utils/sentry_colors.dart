
import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class SentryColors {
  static final MaterialColor primarySwatch = createMaterialColor(rum);

  static const woodSmoke = Color(0xff18181A);
  static const revolver = Color(0xff2B1D38);
  static const rum = Color(0xff776589);
  static const mamba = Color(0xff9386A0);
  static const snuff = Color(0xffE7E1EC);
  static const whisper = Color(0xffFAF9FB);

  static const graySuit = Color(0xffC6BECF);
  static const lavenderGray = Color(0xffB9C1D9);
  static const silverChalice = Color(0xffA4A4A4);

  static const wildBlueYonder = Color(0xff8492BA);

  static const cruise = Color(0xffB6ECDF);
  static const shamrock = Color(0xff33BF9E);

  static const capeHoney = Color(0xffFDE8B4);
  static const lightningYellow = Color(0xffFFC227);

  static const cupid = Color(0xffFCC6C8);

  static const royalBlue = Color(0xff3D74DB);

  static const buttercup = Color(0xfff2b712); // Healthy
  static const eastBay = Color(0xff444674); // Errored
  static const tapestry = Color(0xffa35488); // Abnormal
  static const burntSienna = Color(0xffef7061); // Crashed

  // Util

  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
