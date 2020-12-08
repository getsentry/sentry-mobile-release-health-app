import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/project_with_latest_release.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/release.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel.fromStore(Store<AppState> store)
      : _store = store,
        releases = store.state.globalState.projectsWithLatestReleases,
        loading = store.state.globalState.projectsLoading || store.state.globalState.releasesLoading;

  final Store<AppState> _store;

  final List<ProjectWithLatestRelease> releases;
  final bool loading;

  bool fetchOrganizationsNeeded() {
    return _store.state.globalState.organizations.isEmpty && !_store.state.globalState.projectsLoading;
  }

  void fetchOrganizations() {
    _store.dispatch(FetchOrganizationsAndProjectsAction());
  }

  bool fetchReleasesNeeded() {
    return _store.state.globalState.bookmarkedProjectsByOrganizationSlug().isNotEmpty && !_store.state.globalState.releasesLoading;
  }

  void fetchReleases() {
    _store.dispatch(FetchLatestReleasesAction(_store.state.globalState.bookmarkedProjectsByOrganizationSlug()));
  }
}
