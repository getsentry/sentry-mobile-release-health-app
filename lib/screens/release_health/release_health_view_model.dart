import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/release.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel.fromStore(Store<AppState> store)
      : _store = store,
        _organization = store.state.globalState.selectedOrganization,
        project = store.state.globalState.selectedProject,
        releases = store.state.globalState.releases,
        loading = store.state.globalState.releasesLoading && store.state.globalState.releases.isEmpty;

  final Store<AppState> _store;
  final Organization _organization;

  final Project project;
  final List<Release> releases;
  final bool loading;

  void fetchReleases() {
    _store.dispatch(FetchReleasesAction(_organization.slug, project.id));
  }
}