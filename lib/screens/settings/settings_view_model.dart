import 'package:redux/redux.dart';
import '../../redux/state/app_state.dart';

class SettingsViewModel {
  SettingsViewModel.fromStore(Store<AppState> store) {
    final projects = store.state.globalState
        .projectsByOrganizationSlug
        .values.expand((element) => element)
        .where((element) => element.isBookmarked)
        .map((e) => e.name)
        .join(', ');
    bookmarkedProjects = projects.isNotEmpty ? projects : '--';
  }

  String bookmarkedProjects;
}
