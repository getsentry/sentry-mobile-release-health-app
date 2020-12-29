import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/stat.dart';
import '../../types/stats.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel.fromStore(Store<AppState> store)
    : _store = store,
      releases = store.state.globalState.projectsWithLatestReleases,
      handledStatsByProjectSlug = store.state.globalState.aggregatedStatsByProjectSlug(true),
      unhandledStatsByProjectSlug = store.state.globalState.aggregatedStatsByProjectSlug(false),
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

  final Map<String, Stats> handledStatsByProjectSlug; // Aggregated over all issue stats
  final Map<String, Stats> unhandledStatsByProjectSlug; // Aggregated over all error issue stats

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

  List<LineChartPoint> statsAsLineChartPoints(ProjectWithLatestRelease projectWithLatestRelease, bool handled) {
    var stats = <Stat>[];
    if (handled) {
      stats = handledStatsByProjectSlug[projectWithLatestRelease.project.slug]?.stats24h ?? [];
    } else {
      stats = unhandledStatsByProjectSlug[projectWithLatestRelease.project.slug]?.stats24h ?? [];
    }
    return stats.map((e) => LineChartPoint(e.timestamp.toDouble(), e.value.toDouble())).toList();
  }

  void fetchIssues(ProjectWithLatestRelease projectWithLatestRelease) {
    final organizationSlug = _store.state.globalState.organizationsSlugByProjectSlug[projectWithLatestRelease.project.slug];
    if (organizationSlug == null) {
      return;
    }

    // Only fetch when there is no data available yet
    if (_store.state.globalState.handledIssuesByProjectSlug[projectWithLatestRelease.project.slug] == null) {
      _store.dispatch(
          FetchIssuesAction(
              organizationSlug,
              projectWithLatestRelease.project.slug,
              false
          )
      );
    }
  }
}
