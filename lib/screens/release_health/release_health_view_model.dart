import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/sessions.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/stat.dart';
import '../../types/stats.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel.fromStore(Store<AppState> store)
    : _store = store,
      projects = store.state.globalState.allOrBookmarkedProjectsWithLatestReleases(),
      _sessionByProjectId = store.state.globalState.sessionsByProjectId,
      handledStatsByProjectSlug = store.state.globalState.aggregatedStatsByProjectSlug(true),
      unhandledStatsByProjectSlug = store.state.globalState.aggregatedStatsByProjectSlug(false),
      _fetchProjectsNeeded = !store.state.globalState.projectsFetchedOnce &&
        !store.state.globalState.projectsLoading,
      showProjectEmptyScreen = !store.state.globalState.projectsLoading &&
          store.state.globalState.projectsFetchedOnce &&
          store.state.globalState.projectsByOrganizationSlug.keys.isEmpty,
      showReleaseEmptyScreen = !store.state.globalState.releasesLoading &&
          store.state.globalState.releasesFetchedOnce &&
          store.state.globalState.projectsWithLatestReleases.isEmpty,
      showLoadingScreen = store.state.globalState.projectsLoading || store.state.globalState.releasesLoading;

  final Store<AppState> _store;

  final List<ProjectWithLatestRelease> projects;
  final Map<String, Sessions> _sessionByProjectId;

  final Map<String, Stats> handledStatsByProjectSlug; // Aggregated over all issue stats
  final Map<String, Stats> unhandledStatsByProjectSlug; // Aggregated over all error issue stats

  final bool _fetchProjectsNeeded;

  final bool showProjectEmptyScreen;
  final bool showReleaseEmptyScreen;
  final bool showLoadingScreen;

  void fetchProjectsIfNeeded() {
    if (_fetchProjectsNeeded) {
      fetchProjects();
    }
  }

  void fetchProjects() {
    _store.dispatch(FetchOrganizationsAndProjectsAction());
  }

  Sessions sessionsForProject(Project project) {
    return _sessionByProjectId[project.id];
  }

  List<LineChartPoint> statsAsLineChartPoints(ProjectWithLatestRelease projectWithLatestRelease, bool handled) {
    var stats = <Stat>[];
    if (handled) {
      final handledStatsByProjectSlug = this.handledStatsByProjectSlug[projectWithLatestRelease.project.slug]?.stats24h;
      if (handledStatsByProjectSlug == null) {
        return null;
      } else {
        stats = handledStatsByProjectSlug;
      }
    } else {
      final unhandledStatsByProjectSlug = this.unhandledStatsByProjectSlug[projectWithLatestRelease.project.slug]?.stats24h;
      if (unhandledStatsByProjectSlug == null) {
        return null;
      } else {
        stats = unhandledStatsByProjectSlug;
      }
    }
    return stats.map((e) => LineChartPoint(e.timestamp.toDouble(), e.value.toDouble())).toList();
  }

  void fetchLatestReleaseOrIssues(int index) {
    if (index < projects.length) {
      final projectWithLatestRelease = projects[index];
      if (projectWithLatestRelease != null) {
        _fetchLatestRelease(projectWithLatestRelease);
        _fetchSessions(projectWithLatestRelease);
        _fetchIssues(projectWithLatestRelease);
      }

    }
    if (index + 1 < projects.length) {
      final nextProjectWithLatestRelease = projects[index + 1];
      if (nextProjectWithLatestRelease != null) {
        _fetchLatestRelease(nextProjectWithLatestRelease);
        _fetchSessions(nextProjectWithLatestRelease);
        _fetchIssues(nextProjectWithLatestRelease);
      }
    }
  }

  void _fetchLatestRelease(ProjectWithLatestRelease projectWithLatestRelease) {
    final organizationSlug = _store.state.globalState.organizationsSlugByProjectSlug[projectWithLatestRelease.project.slug];
    if (organizationSlug == null) {
      return;
    }
    _store.dispatch(
      FetchLatestReleaseAction(
          organizationSlug,
          projectWithLatestRelease.project.slug,
          projectWithLatestRelease.project.id,
          projectWithLatestRelease.project.latestRelease.version
      )
    );
  }

  void _fetchIssues(ProjectWithLatestRelease projectWithLatestRelease) {
    if (projectWithLatestRelease.release == null) {
      return;
    }
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

  void _fetchSessions(ProjectWithLatestRelease projectWithLatestRelease) {
    if (projectWithLatestRelease.release == null) {
      return;
    }
    final organizationSlug = _store.state.globalState.organizationsSlugByProjectSlug[projectWithLatestRelease.project.slug];
    if (organizationSlug == null) {
      return;
    }

    // Only fetch when there is no data available yet
    if (_store.state.globalState.sessionsByProjectId[projectWithLatestRelease.project.id] == null) {
      _store.dispatch(
          FetchSessionsAction(
              organizationSlug,
              projectWithLatestRelease.project.id
          )
      );
    }
  }
}
