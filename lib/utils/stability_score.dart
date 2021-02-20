import '../types/session_group.dart';
import '../types/session_status.dart';
import '../types/sessions.dart';

extension StabilityScore on Sessions {
  double crashFreeSessions() {
    return _crashFree((SessionGroup group) {
      return group?.totals?.sumSession;
    });
  }

  double crashFreeUsers() {
    return _crashFree((SessionGroup group) {
      return group?.totals?.countUniqueUsers;
    });
  }

  // Higher order function to calculate crash free value
  double _crashFree(int Function(SessionGroup group) valueFromGroup) {
    int healthy;
    int errored;
    int abnormal;
    int crashed;
    for (final group in groups) {
      if (group?.by?.sessionStatus == SessionStatus.healthy) {
        healthy = valueFromGroup(group);
      } else if (group?.by?.sessionStatus == SessionStatus.errored) {
        errored = valueFromGroup(group);
      } else if (group?.by?.sessionStatus == SessionStatus.abnormal) {
        abnormal = valueFromGroup(group);
      } else if (group?.by?.sessionStatus == SessionStatus.crashed) {
        crashed = valueFromGroup(group);
      }
    }
    if (healthy == null || errored == null || abnormal == null || crashed == null) {
      return null;
    }
    final sum = healthy + abnormal + crashed + errored;
    if (sum == 0) {
      return null;
    } else {
      return 100 - (crashed / sum) * 100;
    }
  }
}
