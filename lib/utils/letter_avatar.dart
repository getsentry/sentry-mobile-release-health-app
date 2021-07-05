import 'dart:ui';
import 'package:flutter/material.dart';

// Source: https://github.com/getsentry/sentry/blob/c62499d1de8414e119e8a199eee4c73a01393e44/src/sentry/utils/avatar.py
class LetterAvatar {
  static const LETTER_AVATAR_COLORS = [
    Color(0xff4674ca), // blue
    Color(0xff315cac), // blue_dark
    Color(0xff57be8c), // green
    Color(0xff3fa372), // green_dark
    Color(0xfff9a66d), // yellow_orange
    Color(0xffec5e44), // red
    Color(0xffe63717), // red_dark
    Color(0xfff868bc), // pink
    Color(0xff6c5fc7), // purple
    Color(0xff4e3fb4), // purple_dark
    Color(0xff57b1be), // teal
    Color(0xff847a8c), // gray
  ];

  static String getInitials(String displayName) {
    var displayNameValue = displayName.trim();
    if (displayNameValue.isEmpty) {
      displayNameValue = '?';
    }
    final names = displayNameValue.split(' ');
    final initials = names.length == 1
        ? names[0][0]
        : names.length > 1
            ? '${names[0][0]}${names[1][0]}'
            : '?';
    return initials.toUpperCase();
  }

  static Color getLetterAvatarColor(String identifier) {
    final hashValue = _hash(identifier);
    final index = hashValue % LETTER_AVATAR_COLORS.length;
    return LETTER_AVATAR_COLORS[index];
  }

  // Helper

  static int _hash(String identifier) {
    return identifier.codeUnits.reduce((a, b) => a + b);
  }
}
