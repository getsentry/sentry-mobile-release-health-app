import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class SettingsViewModel {
  SettingsViewModel.fromStore(Store<AppState> store) {
    _store = store;

    final projects = store.state.globalState.projectsByOrganizationSlug.values
        .expand((element) => element)
        .where((element) =>
            element.latestRelease != null && element.isBookmarked == true)
        .map((e) => e.slug)
        .join(', ');

    bookmarkedProjects = projects.isNotEmpty ? projects : '--';
    sentrySdkEnabled = store.state.globalState.sentrySdkEnabled;
    userInfo = store.state.globalState.me?.email ?? '--';
    version = store.state.globalState.version;
  }

  Store<AppState>? _store;

  String bookmarkedProjects = '--';
  bool sentrySdkEnabled = false;
  String userInfo = '--';
  String version = '--';

  void fetchAuthenticatedUserIfNeeded() {
    final me = _store?.state.globalState.me;
    final authToken = _store?.state.globalState.authToken;
    if (me == null && authToken != null) {
      _store?.dispatch(FetchAuthenticatedUserAction(authToken));
    }
  }
}
