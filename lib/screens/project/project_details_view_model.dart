import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/health/health_card_view_model.dart';

class ProjectDetailsViewModel {

  ProjectDetailsViewModel.from(this.projectId, Store<AppState> store) {
    final project = store.state.globalState.projectsWithSessions.firstWhere((element) => element.id == projectId);
    platform = project.platform;
    title = project.slug;
    _crashFreeSessions = store.state.globalState.crashFreeSessionsByProjectId[projectId];
    _crashFreeSessionsBefore = store.state.globalState.crashFreeSessionsBeforeByProjectId[projectId];
    _crashFreeUsers = store.state.globalState.crashFreeUsersByProjectId[projectId];
    _crashFreeUsersBefore = store.state.globalState.crashFreeUsersBeforeByProjectId[projectId];
  }

  String projectId = '';
  String? platform;
  String title = '--';
  double? _crashFreeSessions;
  double? _crashFreeSessionsBefore;
  double? _crashFreeUsers;
  double? _crashFreeUsersBefore;

  HealthCardViewModel crashFreeSessions() {
    return HealthCardViewModel.crashFreeSessions(
      _crashFreeSessions,
      _crashFreeSessionsBefore,
    );
  }

  HealthCardViewModel crashFreeUsers() {
    return HealthCardViewModel.crashFreeSessions(
      _crashFreeUsers,
      _crashFreeUsersBefore,
    );
  }
}
