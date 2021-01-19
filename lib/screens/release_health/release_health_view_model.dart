import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/session_status.dart';
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
      issueStatsByProjectSlug = store.state.globalState.sessionPointsByProjectId({SessionStatus.errored, SessionStatus.abnormal, SessionStatus.crashed}),
      crashedStatsByProjectSlug = store.state.globalState.sessionPointsByProjectId({SessionStatus.crashed}),
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

  final Map<String, List<LineChartPoint>> issueStatsByProjectSlug;
  final Map<String, List<LineChartPoint>> crashedStatsByProjectSlug;

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
    if (handled) {
      final handledStatsByProjectSlug = issueStatsByProjectSlug[projectWithLatestRelease.project.id];
      if (handledStatsByProjectSlug == null) {
        return null;
      } else {
        return handledStatsByProjectSlug;
      }
    } else {
      final unhandledStatsByProjectSlug = crashedStatsByProjectSlug[projectWithLatestRelease.project.id];
      if (unhandledStatsByProjectSlug == null) {
        return null;
      } else {
        return unhandledStatsByProjectSlug;
      }
    }
  }

  void fetchLatestReleaseOrIssues(int index) {
    if (index < projects.length) {
      final projectWithLatestRelease = projects[index];
      if (projectWithLatestRelease != null) {
        _fetchLatestRelease(projectWithLatestRelease);
        _fetchSessions(projectWithLatestRelease);
      }
    }
    if (index + 1 < projects.length) {
      final nextProjectWithLatestRelease = projects[index + 1];
      if (nextProjectWithLatestRelease != null) {
        _fetchLatestRelease(nextProjectWithLatestRelease);
        _fetchSessions(nextProjectWithLatestRelease);
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
