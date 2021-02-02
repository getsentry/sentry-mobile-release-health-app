import '../types/session_status.dart';
import '../types/sessions.dart';

extension StabilityScore on Sessions {
  double stabilityScore() {
    int healthy;
    int errored;
    int abnormal;
    int crashed;
    for (final group in groups) {
      if (group?.by?.sessionStatus == SessionStatus.healthy) {
        healthy = group?.totals?.sumSession;
      } else if (group?.by?.sessionStatus == SessionStatus.errored) {
        errored = group?.totals?.sumSession;
      } else if (group?.by?.sessionStatus == SessionStatus.abnormal) {
        abnormal = group?.totals?.sumSession;
      } else if (group?.by?.sessionStatus == SessionStatus.crashed) {
        crashed = group?.totals?.sumSession;
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
