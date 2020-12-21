import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/project_with_latest_release.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel.fromStore(Store<AppState> store)
    : _store = store,
      releases = store.state.globalState.projectsWithLatestReleases,
      _fetchProjectsNeeded = !store.state.globalState.projectsFetchedOnce &&
        !store.state.globalState.projectsLoading,
      _fetchReleasesNeeded = store.state.globalState.projectsFetchedOnce &&
        !store.state.globalState.projectsLoading &&
        !store.state.globalState.releasesFetchedOnce &&
        !store.state.globalState.releasesLoading,
      showProjectEmptyScreen = !store.state.globalState.projectsLoading &&
          store.state.globalState.projectsFetchedOnce &&
          store.state.globalState.projectsByOrganizationSlug.keys.isEmpty,
      showReleaseEmptyScreen = !store.state.globalState.releasesLoading &&
          store.state.globalState.releasesFetchedOnce &&
          store.state.globalState.projectsWithLatestReleases.isEmpty,
      showLoadingScreen = store.state.globalState.projectsLoading || store.state.globalState.releasesLoading;

  final Store<AppState> _store;

  final List<ProjectWithLatestRelease> releases;

  final bool _fetchProjectsNeeded;
  final bool _fetchReleasesNeeded;

  final bool showProjectEmptyScreen;
  final bool showReleaseEmptyScreen;
  final bool showLoadingScreen;

  void fetchProjectsIfNeeded() {
    if (_fetchProjectsNeeded) {
      _store.dispatch(FetchOrganizationsAndProjectsAction());
    }
  }

  void fetchReleasesIfNeeded() {
    if (_fetchReleasesNeeded) {
      fetchReleases();
    }
  }

  void fetchReleases() {
    _store.dispatch(FetchLatestReleasesAction(_store.state.globalState.bookmarkedProjectsByOrganizationSlug()));
  }
}
