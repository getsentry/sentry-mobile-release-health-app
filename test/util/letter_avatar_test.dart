import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_mobile/utils/letter_avatar.dart';

// Source: https://github.com/getsentry/sentry/blob/c62499d1de8414e119e8a199eee4c73a01393e44/tests/sentry/utils/test_letter_avatar.py
void main() {
  group('test_letter_avatar', () {
    test('Test name as display name and email as identifier', () {
      expect(LetterAvatar.getInitials('Jane Bloggs'), equals('JB'));

      final color = LetterAvatar.getLetterAvatarColor('janebloggs@example.com');
      final colorHex = color.value.toRadixString(16);
      expect(colorHex, equals('ff4e3fb4')); // purple_dark
    });

    test('Test email as display name and id as identifier', () {
      expect(LetterAvatar.getInitials('johnsmith@example.com'), equals('J'));

      final color = LetterAvatar.getLetterAvatarColor('2');
      final colorHex = color.value.toRadixString(16);
      expect(colorHex, equals('ff57be8c')); // green
    });

    test('Test display name with trailing spaces', () {
      expect(LetterAvatar.getInitials('johnsmith@example.com '), equals('J'));

      final color = LetterAvatar.getLetterAvatarColor('2');
      final colorHex = color.value.toRadixString(16);
      expect(colorHex, equals('ff57be8c')); // green
    });
  });
}
