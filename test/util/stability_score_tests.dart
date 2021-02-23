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
      expect(sessions.crashFreeSessions(), isNull);

      sessions = Sessions([], [healthy, errored]);
      expect(sessions.crashFreeSessions(), isNull);

      sessions = Sessions([], [healthy, errored, abnormal]);
      expect(sessions.crashFreeSessions(), isNull);

      sessions = Sessions([], [errored, abnormal, crashed]);
      expect(sessions.crashFreeSessions(), isNull);
    });

    test('stability score', () {
      final healthy = _givenSessionGroup(SessionStatus.healthy, 1);
      final errored = _givenSessionGroup(SessionStatus.errored, 1);
      final abnormal = _givenSessionGroup(SessionStatus.abnormal, 1);
      final crashed = _givenSessionGroup(SessionStatus.crashed, 1);

      final sessions = Sessions([], [healthy, errored, abnormal, crashed]);
      expect(sessions.crashFreeSessions(), equals(75.0));
    });

    test('all zero equals null', () {
      final healthy = _givenSessionGroup(SessionStatus.healthy, 0);
      final errored = _givenSessionGroup(SessionStatus.errored, 0);
      final abnormal = _givenSessionGroup(SessionStatus.abnormal, 0);
      final crashed = _givenSessionGroup(SessionStatus.crashed, 0);

      final sessions = Sessions([], [healthy, errored, abnormal, crashed]);
      expect(sessions.crashFreeSessions(), isNull);
    });

  });
}

SessionGroup _givenSessionGroup(SessionStatus status, int num) {
  return SessionGroup(
      SessionGroupBy(status, null),
      SessionGroupTotals(num, num),
      SessionGroupSeries([], [])
  );
}
