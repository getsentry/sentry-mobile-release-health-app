import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/release.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel(this._store, this._organization, this.project, this.releases, this.loading);
  final Store<AppState> _store;
  final Organization _organization;

  final Project project;
  List<Release> releases;
  bool loading;

  static ReleaseHealthViewModel fromStore(Store<AppState> store) =>
      ReleaseHealthViewModel(
          store,
          store.state.globalState.selectedOrganization,
          store.state.globalState.selectedProject,
          store.state.globalState.releases,
          store.state.globalState.releasesLoading && store.state.globalState.releases.isEmpty
      );

  void fetchReleases() {
    _store.dispatch(FetchReleasesAction(_organization.slug, project.id));
  }
}