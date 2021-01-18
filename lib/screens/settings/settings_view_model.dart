import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class SettingsViewModel {
  SettingsViewModel.fromStore(Store<AppState> store) {
    _store = store;

    final projects = store.state.globalState
        .projectsByOrganizationSlug
        .values.expand((element) => element)
        .where((element) => element.isBookmarked)
        .map((e) => e.slug)
        .join(', ');
    bookmarkedProjects = projects.isNotEmpty ? projects : '--';

    final me = store.state.globalState.me;
    final username = me?.username;
    final email = me?.email;
    if (username != null && email != null) {
      userInfo  = username != email ? '$username $email' : username;
    } else {
      userInfo = '--';
    }
  }

  Store<AppState> _store;

  String bookmarkedProjects;
  String userInfo;

  void fetchAuthenticatedUserIfNeeded() {
    if (_store.state.globalState.me == null) {
      _store.dispatch(FetchAuthenticatedUserAction());
    }
  }
}
