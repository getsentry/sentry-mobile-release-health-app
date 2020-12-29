import 'package:redux/redux.dart';
import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class SettingsViewModel {
  SettingsViewModel.fromStore(Store<AppState> store) {
    final projects = store.state.globalState
        .bookmarkedProjectsByOrganizationSlug()
        .values.expand((element) => element).map((e) => e.name)
        .join(', ');
    bookmarkedProjects = projects.isNotEmpty ? projects : '--';
  }

  String bookmarkedProjects;
}
