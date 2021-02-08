import 'package:redux/redux.dart';
import 'package:sentry_mobile/screens/health/health_card_view_model.dart';

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
      _totalSessionStateByProjectId = store.state.globalState.sessionStateByProjectId(SessionStatus.values.toSet()),
      _healthySessionsStateByProjectId = store.state.globalState.sessionStateByProjectId({SessionStatus.healthy}),
      _erroredSessionsStateByProjectId = store.state.globalState.sessionStateByProjectId({SessionStatus.errored}),
      _abnormalSessionsStateByProjectId = store.state.globalState.sessionStateByProjectId({SessionStatus.abnormal}),
      _crashedSessionStateByProjectId = store.state.globalState.sessionStateByProjectId({SessionStatus.crashed}),
      _stabilityScoreByProjectId = store.state.globalState.stabilityScoreByProjectId,
      _stabilityScoreBeforeByProjectId = store.state.globalState.stabilityScoreBeforeByProjectId,
      _apdexByProjectId = store.state.globalState.apdexByProjectId,
      _apdexBeforeByProjectId = store.state.globalState.apdexBeforeByProjectId,
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

  final Map<String, SessionState> _totalSessionStateByProjectId;
  final Map<String, SessionState> _healthySessionsStateByProjectId;
  final Map<String, SessionState> _erroredSessionsStateByProjectId;
  final Map<String, SessionState> _abnormalSessionsStateByProjectId;
  final Map<String, SessionState> _crashedSessionStateByProjectId;

  final Map<String, double> _stabilityScoreByProjectId;
  final Map<String, double> _stabilityScoreBeforeByProjectId;

  final Map<String, double> _apdexByProjectId;
  final Map<String, double> _apdexBeforeByProjectId;
  
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

  SessionState totalSessionStateForProject(Project project) {
    return _totalSessionStateByProjectId[project.id];
  }
  
  SessionState sessionState(int index, SessionStatus sessionStatus) {
    final project = projects[index].project;

    switch (sessionStatus) {
      case SessionStatus.healthy:
        return _healthySessionsStateByProjectId[project.id];
      case SessionStatus.errored:
        return _erroredSessionsStateByProjectId[project.id];
      case SessionStatus.crashed:
        return _crashedSessionStateByProjectId[project.id];
      case SessionStatus.abnormal:
        return _abnormalSessionsStateByProjectId[project.id];
    }
    return null;
  }

  HealthCardViewModel stabilityScoreForProject(Project project) {
    return HealthCardViewModel.stabilityScore(
      _stabilityScoreByProjectId[project.id],
      _stabilityScoreBeforeByProjectId[project.id],
    );
  }

  HealthCardViewModel apdexForProject(Project project) {
    return HealthCardViewModel.apdex(
      _apdexByProjectId[project.id],
      _apdexBeforeByProjectId[project.id],
    );
  }
  
  void fetchDataForProject(int index) {
    if (index < projects.length) {
      final projectWithLatestRelease = projects[index];
      if (projectWithLatestRelease != null) {
        _fetchLatestRelease(projectWithLatestRelease);
        _fetchSessions(projectWithLatestRelease);
        _fetchApdex(projectWithLatestRelease);
      }
    }
    if (index + 1 < projects.length) {
      final nextProjectWithLatestRelease = projects[index + 1];
      if (nextProjectWithLatestRelease != null) {
        _fetchLatestRelease(nextProjectWithLatestRelease);
        _fetchSessions(nextProjectWithLatestRelease);
        _fetchApdex(nextProjectWithLatestRelease);
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
  void _fetchApdex(ProjectWithLatestRelease projectWithLatestRelease) {
    final organization = _store.state.globalState.organizationForProjectSlug(projectWithLatestRelease.project.slug);
    if (organization == null) {
      return;
    }
    _store.dispatch(
        FetchApdexAction(
          organization.apdexThreshold,
          organization.slug,
          projectWithLatestRelease.project.id,
        )
    );
  }
}
