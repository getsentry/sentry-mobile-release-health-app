import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_mobile/types/session_group.dart';
import 'package:sentry_mobile/types/session_group_by.dart';
import 'package:sentry_mobile/types/session_group_series.dart';
import 'package:sentry_mobile/types/session_group_totals.dart';
import 'package:sentry_mobile/types/session_status.dart';
import 'package:sentry_mobile/types/sessions.dart';
import 'package:sentry_mobile/utils/stability_score.dart';

void main() {
  group('StabilityScore', () {
    test('null if missing groups', () {
      final healthy = _givenSessionGroup(SessionStatus.healthy, 1);
      final errored = _givenSessionGroup(SessionStatus.errored, 1);
      final abnormal = _givenSessionGroup(SessionStatus.abnormal, 1);
      final crashed = _givenSessionGroup(SessionStatus.crashed, 1);

      var sessions = Sessions([], [healthy]);
      expect(sessions.stabilityScore(), isNull);

      sessions = Sessions([], [healthy, errored]);
      expect(sessions.stabilityScore(), isNull);

      sessions = Sessions([], [healthy, errored, abnormal]);
      expect(sessions.stabilityScore(), isNull);

      sessions = Sessions([], [errored, abnormal, crashed]);
      expect(sessions.stabilityScore(), isNull);
    });

    test('stability score', () {
      final healthy = _givenSessionGroup(SessionStatus.healthy, 1);
      final errored = _givenSessionGroup(SessionStatus.errored, 1);
      final abnormal = _givenSessionGroup(SessionStatus.abnormal, 1);
      final crashed = _givenSessionGroup(SessionStatus.crashed, 1);

      final sessions = Sessions([], [healthy, errored, abnormal, crashed]);
      expect(sessions.stabilityScore(), equals(75.0));
    });

    test('all zero equals 100', () {
      final healthy = _givenSessionGroup(SessionStatus.healthy, 0);
      final errored = _givenSessionGroup(SessionStatus.errored, 0);
      final abnormal = _givenSessionGroup(SessionStatus.abnormal, 0);
      final crashed = _givenSessionGroup(SessionStatus.crashed, 0);

      final sessions = Sessions([], [healthy, errored, abnormal, crashed]);
      expect(sessions.stabilityScore(), equals(100.0));
    });

  });
}

SessionGroup _givenSessionGroup(SessionStatus status, int num) {
  return SessionGroup(
      SessionGroupBy(status),
      SessionGroupTotals(num),
      SessionGroupSeries([])
  );
}
