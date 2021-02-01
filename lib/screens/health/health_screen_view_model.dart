import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../redux/state/session_state.dart';
import '../../types/project.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/session_status.dart';

class HealthScreenViewModel {
  HealthScreenViewModel.fromStore(Store<AppState> store)
    : _store = store,
      projects = store.state.globalState.allOrBookmarkedProjectsWithLatestReleases(),
      _sessionStateByProjectId = store.state.globalState.sessionStateByProjectId(SessionStatus.values.toSet()),
      _handledAndCrashedSessionStateByProjectId = store.state.globalState.sessionStateByProjectId({SessionStatus.errored, SessionStatus.abnormal, SessionStatus.crashed}),
      _crashedSessionStateByProjectId = store.state.globalState.sessionStateByProjectId({SessionStatus.crashed}),
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

  final Map<String, SessionState> _sessionStateByProjectId;
  final Map<String, SessionState> _handledAndCrashedSessionStateByProjectId;
  final Map<String, SessionState> _crashedSessionStateByProjectId;

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

  SessionState sessionStateForProject(Project project) {
    return _sessionStateByProjectId[project.id];
  }

  SessionState handledAndCrashedSessionStateForProject(Project project) {
    return _handledAndCrashedSessionStateByProjectId[project.id];
  }

  SessionState crashedSessionStateForProject(Project project) {
    return _crashedSessionStateByProjectId[project.id];
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
