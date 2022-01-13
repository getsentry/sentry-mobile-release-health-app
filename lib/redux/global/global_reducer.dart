import 'package:redux/redux.dart';

import '../../api/api_errors.dart';
import '../../types/project.dart';
import '../../types/release.dart';
import '../../utils/collections.dart';
import '../../utils/stability_score.dart';
import '../actions.dart';
import 'global_state.dart';

final globalReducer = combineReducers<GlobalState>([
  TypedReducer<GlobalState, SwitchTabAction>(_switchTabAction),
  TypedReducer<GlobalState, RehydrateSuccessAction>(_rehydrateSuccessAction),
  TypedReducer<GlobalState, LoginSuccessAction>(_loginAction),
  TypedReducer<GlobalState, LogoutAction>(_logoutAction),
  TypedReducer<GlobalState, FetchOrgsAndProjectsAction>(
      _fetchOrganizationsAndProjectsAction),
  TypedReducer<GlobalState, FetchOrgsAndProjectsProgressAction>(
      _fetchOrgsAndProjectsProgressAction),
  TypedReducer<GlobalState, FetchOrgsAndProjectsSuccessAction>(
      _fetchOrgsAndProjectsSuccessAction),
  TypedReducer<GlobalState, FetchOrgsAndProjectsFailureAction>(
      _fetchOrgsAndProjectsFailure),
  TypedReducer<GlobalState, FetchLatestReleasesAction>(
      _fetchLatestReleasesAction),
  TypedReducer<GlobalState, FetchLatestReleasesSuccessAction>(
      _fetchLatestReleasesSuccessAction),
  TypedReducer<GlobalState, FetchLatestReleaseSuccessAction>(
      _fetchLatestReleaseSuccessAction),
  TypedReducer<GlobalState, FetchIssuesSuccessAction>(
      _fetchIssuesSuccessAction),
  TypedReducer<GlobalState, SelectOrganizationAction>(
      _selectOrganizationAction),
  TypedReducer<GlobalState, SelectProjectAction>(_selectProjectAction),
  TypedReducer<GlobalState, FetchAuthenticatedUserSuccessAction>(
      _fetchAuthenticatedUserSuccessAction),
  TypedReducer<GlobalState, FetchSessionsSuccessAction>(
      _fetchSessionsSuccessAction),
  TypedReducer<GlobalState, FetchApdexSuccessAction>(_fetchApdexSuccessAction),
  TypedReducer<GlobalState, BookmarkProjectAction>(_bookmarkProjectAction),
  TypedReducer<GlobalState, BookmarkProjectSuccessAction>(
      _bookmarkProjectSuccessAction),
  TypedReducer<GlobalState, BookmarkProjectFailureAction>(
      _bookmarkProjectFailureAction),
  TypedReducer<GlobalState, SentrySdkToggleAction>(_sentrySdkToggle),
  TypedReducer<GlobalState, ApiFailureAction>(_apiFailureAction)
]);

GlobalState _fetchOrgsAndProjectsProgressAction(
    GlobalState state, FetchOrgsAndProjectsProgressAction action) {
  return state.copyWith(
      orgsAndProjectsProgress: action.progress,
      orgsAndProjectsProgressText: action.text);
}

GlobalState _switchTabAction(GlobalState state, SwitchTabAction action) {
  return state.copyWith(selectedTab: action.selectedTab);
}

GlobalState _rehydrateSuccessAction(
    GlobalState state, RehydrateSuccessAction action) {
  return state.copyWith(
    hydrated: true,
    authToken: action.authToken,
    sentrySdkEnabled: action.sentrySdkEnabled,
    version: action.version,
  );
}

GlobalState _loginAction(GlobalState state, LoginSuccessAction action) {
  return state.copyWith(authToken: action.authToken);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return GlobalState.initial().copyWith(hydrated: true);
}

GlobalState _fetchOrganizationsAndProjectsAction(
    GlobalState state, FetchOrgsAndProjectsAction action) {
  if (action.resetSessionData) {
    return state.copyWith(
        sessionsByProjectId: {},
        sessionsBeforeByProjectId: {},
        orgsAndProjectsLoading: true,
        setOrgsAndProjectsErrorNull: true);
  } else {
    return state.copyWith(
        orgsAndProjectsLoading: true, setOrgsAndProjectsErrorNull: true);
  }
}

GlobalState _fetchOrgsAndProjectsSuccessAction(
    GlobalState state, FetchOrgsAndProjectsSuccessAction action) {
  final Map<String, String> organizationsSlugByProjectSlug = <String, String>{};
  final Map<String, Project> projectsById = <String, Project>{};

  for (final project in state.projects) {
    projectsById[project.id] = project;
  }

  for (final organizationSlug in action.projectsByOrganizationSlug.keys) {
    for (final project
        in action.projectsByOrganizationSlug[organizationSlug]!) {
      organizationsSlugByProjectSlug[project.slug] = organizationSlug;

      projectsById[project.id] = project;
    }
  }

  final projects = projectsById.values.toList();

  projects.sort((Project a, Project b) {
    return a.slug.toLowerCase().compareTo(b.slug.toLowerCase());
  });
  projects.sort((Project a, Project b) {
    final valueA = action.projectIdsWithSessions.contains(a.id) ? 0 : 1;
    final valueB = action.projectIdsWithSessions.contains(b.id) ? 0 : 1;
    return valueA.compareTo(valueB);
  });
  projects.sort((Project a, Project b) {
    final valueA = a.isBookmarked! ? 0 : 1;
    final valueB = b.isBookmarked! ? 0 : 1;
    return valueA.compareTo(valueB);
  });
  return state.copyWith(
      organizations: action.organizations,
      organizationsSlugByProjectSlug: organizationsSlugByProjectSlug,
      projectIdsWithSessions: action.projectIdsWithSessions,
      projects: projects,
      projectsByOrganizationSlug: action.projectsByOrganizationSlug,
      orgsAndProjectsLoading: false);
}

GlobalState _fetchOrgsAndProjectsFailure(
    GlobalState state, FetchOrgsAndProjectsFailureAction action) {
  return state.copyWith(
    orgsAndProjectsLoading: false,
    orgsAndProjectsError: action.error,
  );
}

GlobalState _selectOrganizationAction(
    GlobalState state, SelectOrganizationAction action) {
  return state.copyWith(selectedOrganization: action.organization);
}

GlobalState _selectProjectAction(
    GlobalState state, SelectProjectAction action) {
  return state.copyWith(selectedProject: action.project);
}

GlobalState _fetchLatestReleasesAction(
    GlobalState state, FetchLatestReleasesAction action) {
  return state.copyWith();
}

GlobalState _fetchLatestReleasesSuccessAction(
    GlobalState state, FetchLatestReleasesSuccessAction action) {
  final Map<String, Release> latestReleasesByProjectId = <String, Release>{};

  for (final projectsWithLatestRelease in action.projectsWithLatestReleases) {
    final release = projectsWithLatestRelease.release;
    if (release != null) {
      latestReleasesByProjectId[projectsWithLatestRelease.project.id] = release;
    }
  }

  return state.copyWith(latestReleasesByProjectId: latestReleasesByProjectId);
}

GlobalState _fetchLatestReleaseSuccessAction(
    GlobalState state, FetchLatestReleaseSuccessAction action) {
  final organizationSlug =
      state.organizationsSlugByProjectSlug[action.projectSlug];
  final project = state.projectsByOrganizationSlug[organizationSlug!]!
      .where((element) => element.slug == action.projectSlug)
      .first;

  final Map<String, Release> latestReleasesByProjectId =
      state.latestReleasesByProjectId;
  latestReleasesByProjectId[project.id] = action.latestRelease;

  return state.copyWith(
    latestReleasesByProjectId: latestReleasesByProjectId,
  );
}

GlobalState _fetchIssuesSuccessAction(
    GlobalState state, FetchIssuesSuccessAction action) {
  final issuesByProjectSlug = state.issuesByProjectSlug;
  issuesByProjectSlug[action.projectSlug] = action.issues;

  return state.copyWith(issuesByProjectSlug: issuesByProjectSlug);
}

GlobalState _fetchAuthenticatedUserSuccessAction(
    GlobalState state, FetchAuthenticatedUserSuccessAction action) {
  return state.copyWith(me: action.me);
}

GlobalState _fetchSessionsSuccessAction(
    GlobalState state, FetchSessionsSuccessAction action) {
  final sessionsByProjectId = state.sessionsByProjectId;
  sessionsByProjectId[action.projectId] = action.sessions;

  final sessionsBeforeByProjectId = state.sessionsBeforeByProjectId;
  sessionsBeforeByProjectId[action.projectId] = action.sessionsBefore;

  final Map<String, double> crashFreeSessionsByProjectId =
      state.crashFreeSessionsByProjectId;
  final sessionsCrashFreeSessions = action.sessions.crashFreeSessions();
  if (sessionsCrashFreeSessions != null) {
    crashFreeSessionsByProjectId[action.projectId] = sessionsCrashFreeSessions;
  }

  final Map<String, double> crashFreeSessionsBeforeByProjectId =
      state.crashFreeSessionsBeforeByProjectId;
  final sessionsBeforeCrashFreeSessions =
      action.sessionsBefore.crashFreeSessions();
  if (sessionsBeforeCrashFreeSessions != null) {
    crashFreeSessionsBeforeByProjectId[action.projectId] =
        sessionsBeforeCrashFreeSessions;
  }

  final Map<String, double> crashFreeUsersByProjectId =
      state.crashFreeUsersByProjectId;
  final sessionsCrashFreeUsers = action.sessions.crashFreeUsers();
  if (sessionsCrashFreeUsers != null) {
    crashFreeUsersByProjectId[action.projectId] = sessionsCrashFreeUsers;
  }

  final Map<String, double> crashFreeUsersBeforeByProjectId =
      state.crashFreeUsersBeforeByProjectId;
  final sessionsBeforeCrashFreeUsers = action.sessionsBefore.crashFreeUsers();
  if (sessionsBeforeCrashFreeUsers != null) {
    crashFreeUsersBeforeByProjectId[action.projectId] =
        sessionsBeforeCrashFreeUsers;
  }

  return state.copyWith(
      sessionsByProjectId: sessionsByProjectId,
      sessionsBeforeByProjectId: sessionsBeforeByProjectId,
      crashFreeSessionsByProjectId: crashFreeSessionsByProjectId,
      crashFreeSessionsBeforeByProjectId: crashFreeSessionsBeforeByProjectId,
      crashFreeUsersByProjectId: crashFreeUsersByProjectId,
      crashFreeUsersBeforeByProjectId: crashFreeUsersBeforeByProjectId);
}

GlobalState _fetchApdexSuccessAction(
    GlobalState state, FetchApdexSuccessAction action) {
  final apdexByProjectId = state.apdexByProjectId;
  final apdex = action.apdex;
  if (apdex != null) {
    apdexByProjectId[action.projectId] = apdex;
  }

  final apdexBeforeByProjectId = state.apdexBeforeByProjectId;
  final apdexBefore = action.apdexBefore;
  if (apdexBefore != null) {
    apdexBeforeByProjectId[action.projectId] = apdexBefore;
  }

  return state.copyWith(
      apdexByProjectId: apdexByProjectId,
      apdexBeforeByProjectId: apdexBeforeByProjectId);
}

GlobalState _bookmarkProjectAction(
    GlobalState state, BookmarkProjectAction action) {
  final project = state.projects
      .firstWhereOrNull((element) => element.slug == action.projectSlug);
  if (project != null) {
    return _replaceProject(
        state, project.copyWith(isBookmarked: action.bookmarked));
  } else {
    return state;
  }
}

GlobalState _bookmarkProjectSuccessAction(
    GlobalState state, BookmarkProjectSuccessAction action) {
  return _replaceProject(state, action.project);
}

GlobalState _bookmarkProjectFailureAction(
    GlobalState state, BookmarkProjectFailureAction action) {
  final project = state.projects
      .firstWhereOrNull((element) => element.slug == action.projectSlug);
  if (project != null) {
    return _replaceProject(
        state, project.copyWith(isBookmarked: action.bookmarked));
  } else {
    return state;
  }
}

GlobalState _sentrySdkToggle(GlobalState state, SentrySdkToggleAction action) {
  return state.copyWith(sentrySdkEnabled: action.enabled);
}

GlobalState _apiFailureAction(GlobalState state, ApiFailureAction action) {
  final error = action.error;
  if (error is ApiError && error.statusCode == 401) {
    return _logoutAction(state, LogoutAction());
  } else {
    return state;
  }
}

// Helpers

GlobalState _replaceProject(GlobalState state, Project projectToReplace) {
  final projectsByOrganizationSlug = <String, List<Project>>{};
  final projects = <Project>[];

  for (final project in state.projects) {
    if (project.id == projectToReplace.id) {
      projects.add(projectToReplace);
    } else {
      projects.add(project);
    }
  }

  for (final organizationSlug in state.projectsByOrganizationSlug.keys) {
    final projects = <Project>[];
    for (final project in state.projectsByOrganizationSlug[organizationSlug]!) {
      if (project.id == projectToReplace.id) {
        projects.add(projectToReplace);
      } else {
        projects.add(project);
      }
    }
    projectsByOrganizationSlug[organizationSlug] = projects;
  }

  projects.sort((Project a, Project b) {
    return a.slug.toLowerCase().compareTo(b.slug.toLowerCase());
  });
  projects.sort((Project a, Project b) {
    final valueA = state.projectIdsWithSessions.contains(a.id) ? 0 : 1;
    final valueB = state.projectIdsWithSessions.contains(b.id) ? 0 : 1;
    return valueA.compareTo(valueB);
  });
  projects.sort((Project a, Project b) {
    final valueA = a.isBookmarked! ? 0 : 1;
    final valueB = b.isBookmarked! ? 0 : 1;
    return valueA.compareTo(valueB);
  });

  return state.copyWith(
      projectsByOrganizationSlug: projectsByOrganizationSlug,
      projects: projects);
}

// -----------------------------
