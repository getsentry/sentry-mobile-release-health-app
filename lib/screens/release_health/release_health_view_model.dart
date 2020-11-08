import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/release.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel(this._store, this._organization, this._project, this.releases, this.loading);
  final Store<AppState> _store;
  final Organization _organization;
  final Project _project;

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
    _store.dispatch(FetchReleasesAction(_organization.slug, _project.id));
  }
}