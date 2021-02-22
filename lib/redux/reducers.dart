import 'package:redux/redux.dart';

import '../api/api_errors.dart';
import '../types/project.dart';
import '../types/release.dart';
import '../utils/stability_score.dart';
import 'actions.dart';
import 'state/app_state.dart';

AppState appReducer(AppState state, dynamic action) =>
    AppState(
      globalState: globalReducer(state.globalState, action),
    );

final globalReducer = combineReducers<GlobalState>([
  TypedReducer<GlobalState, SwitchTabAction>(_switchTabAction),
  TypedReducer<GlobalState, RehydrateSuccessAction>(_rehydrateSuccessAction),
  TypedReducer<GlobalState, LoginAction>(_loginAction),
  TypedReducer<GlobalState, LogoutAction>(_logoutAction),
  TypedReducer<GlobalState, FetchOrganizationsAndProjectsAction>(_fetchOrganizationsAndProjectsAction),
  TypedReducer<GlobalState, FetchOrganizationsAndProjectsSuccessAction>(_fetchOrganizationsAndProjectsSuccessAction),
  TypedReducer<GlobalState, FetchLatestReleasesAction>(_fetchLatestReleasesAction),
  TypedReducer<GlobalState, FetchLatestReleasesSuccessAction>(_fetchLatestReleasesSuccessAction),
  TypedReducer<GlobalState, FetchLatestReleaseSuccessAction>(_fetchLatestReleaseSuccessAction),
  TypedReducer<GlobalState, FetchIssuesSuccessAction>(_fetchIssuesSuccessAction),
  TypedReducer<GlobalState, SelectOrganizationAction>(_selectOrganizationAction),
  TypedReducer<GlobalState, SelectProjectAction>(_selectProjectAction),
  TypedReducer<GlobalState, FetchAuthenticatedUserSuccessAction>(_fetchAuthenticatedUserSuccessAction),
  TypedReducer<GlobalState, FetchSessionsSuccessAction>(_fetchSessionsSuccessAction),
  TypedReducer<GlobalState, FetchApdexSuccessAction>(_fetchApdexSuccessAction),
  TypedReducer<GlobalState, BookmarkProjectSuccessAction>(_bookmarkProjectSuccessAction),
  TypedReducer<GlobalState, ApiFailureAction>(_apiFailureAction),
]);

GlobalState _switchTabAction(GlobalState state, SwitchTabAction action) {
  return state.copyWith(selectedTab: action.selectedTab);
}

GlobalState _rehydrateSuccessAction(GlobalState state, RehydrateSuccessAction action) {
  return state.copyWith(hydrated: true, authToken: action.authToken, version: action.version);
}

GlobalState _loginAction(GlobalState state, LoginAction action) {
  return state.copyWith(authToken: action.authToken);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return GlobalState.initial().copyWith(
      hydrated: true
  );
}

GlobalState _fetchOrganizationsAndProjectsAction(GlobalState state, FetchOrganizationsAndProjectsAction action) {
  if (action.reload) {
    return state.copyWith(
      sessionsByProjectId: {},
      sessionsBeforeByProjectId: {}
    );
  } else {
    return state;
  }
}

GlobalState _fetchOrganizationsAndProjectsSuccessAction(GlobalState state, FetchOrganizationsAndProjectsSuccessAction action) {
  final organizationsSlugByProjectSlug = action.reload
      ? <String, String>{}
      : state.organizationsSlugByProjectSlug;

  final projectsById = <String, Project>{};

  if (!action.reload) {
    for (final project in state.projects) {
      projectsById[project.id] = project;
    }
  }

  for (final organizationSlug in action.projectsByOrganizationSlug.keys) {
    for (final project in action.projectsByOrganizationSlug[organizationSlug]) {
      if (project.latestRelease != null) {
        organizationsSlugByProjectSlug[project.slug] = organizationSlug;
        projectsById[project.id] = project;
      }
    }
  }

  final projects = projectsById.values.toList();

  projects.sort((Project a, Project b) {
    return (a.slug ?? a.name).toLowerCase().compareTo((b.slug ?? b.name).toLowerCase());
  });
  projects.sort((Project a, Project b) {
    final valueA = a.isBookmarked ? 0 : 1;
    final valueB = b.isBookmarked ? 0 : 1;
    return valueA.compareTo(valueB);
  });

  return state.copyWith(
    organizations: action.organizations,
    organizationsSlugByProjectSlug: organizationsSlugByProjectSlug,
    projectCursorsByOrganizationSlug: action.projectCursorsByOrganizationSlug,
    projectsByOrganizationSlug: action.projectsByOrganizationSlug,
    projects: projects,
    projectsFetchedOnce: true,
  );
}

GlobalState _selectOrganizationAction(GlobalState state, SelectOrganizationAction action) {
  return state.copyWith(selectedOrganization: action.organization);
}

GlobalState _selectProjectAction(GlobalState state, SelectProjectAction action) {
  return state.copyWith(selectedProject: action.project);
}

GlobalState _fetchLatestReleasesAction(GlobalState state, FetchLatestReleasesAction action) {
  return state.copyWith();
}

GlobalState _fetchLatestReleasesSuccessAction(GlobalState state, FetchLatestReleasesSuccessAction action) {
  final projects = <Project>[];
  final latestReleasesByProjectId = <String, Release>{};

  for (final projectsWithLatestRelease in action.projectsWithLatestReleases) {
    projects.add(projectsWithLatestRelease.project);
    latestReleasesByProjectId[projectsWithLatestRelease.project.id] = projectsWithLatestRelease.release;
  }

  return state.copyWith(
    projects: projects,
    latestReleasesByProjectId: latestReleasesByProjectId
  );
}

GlobalState _fetchLatestReleaseSuccessAction(GlobalState state, FetchLatestReleaseSuccessAction action) {
  final organizationSlug = state.organizationsSlugByProjectSlug[action.projectSlug];
  final project = state.projectsByOrganizationSlug[organizationSlug].where((element) => element.slug == action.projectSlug).first;

  final latestReleasesByProjectId = state.latestReleasesByProjectId;
  latestReleasesByProjectId[project.id] = action.latestRelease;

  return state.copyWith(
      latestReleasesByProjectId: latestReleasesByProjectId,
  );
}

GlobalState _fetchIssuesSuccessAction(GlobalState state, FetchIssuesSuccessAction action) {
  final issuesByProjectSlug = state.issuesByProjectSlug;
  issuesByProjectSlug[action.projectSlug] = action.issues;

  return state.copyWith(
      issuesByProjectSlug: issuesByProjectSlug
  );
}

GlobalState _fetchAuthenticatedUserSuccessAction(GlobalState state, FetchAuthenticatedUserSuccessAction action) {
  return state.copyWith(
      me: action.me
  );
}

GlobalState _fetchSessionsSuccessAction(GlobalState state, FetchSessionsSuccessAction action) {
  final sessionsByProjectId = state.sessionsByProjectId;
  sessionsByProjectId[action.projectId] = action.sessions;

  final sessionsBeforeByProjectId = state.sessionsBeforeByProjectId;
  sessionsBeforeByProjectId[action.projectId] = action.sessionsBefore;
  
  final crashFreeSessionsByProjectId = state.crashFreeSessionsByProjectId;
  crashFreeSessionsByProjectId[action.projectId] = action.sessions.crashFreeSessions();
  
  final crashFreeSessionsBeforeByProjectId = state.crashFreeSessionsBeforeByProjectId;
  crashFreeSessionsBeforeByProjectId[action.projectId] = action.sessionsBefore.crashFreeSessions();

  final crashFreeUsersByProjectId = state.crashFreeUsersByProjectId;
  crashFreeUsersByProjectId[action.projectId] = action.sessions.crashFreeUsers();

  final crashFreeUsersBeforeByProjectId = state.crashFreeUsersBeforeByProjectId;
  crashFreeUsersBeforeByProjectId[action.projectId] = action.sessionsBefore.crashFreeUsers();
  
  return state.copyWith(
      sessionsByProjectId: sessionsByProjectId,
      sessionsBeforeByProjectId: sessionsBeforeByProjectId,
      crashFreeSessionsByProjectId: crashFreeSessionsByProjectId,
      crashFreeSessionsBeforeByProjectId: crashFreeSessionsBeforeByProjectId,
      crashFreeUsersByProjectId: crashFreeUsersByProjectId,
      crashFreeUsersBeforeByProjectId: crashFreeUsersBeforeByProjectId
  );
}

GlobalState _fetchApdexSuccessAction(GlobalState state, FetchApdexSuccessAction action) {
  final apdexByProjectId = state.apdexByProjectId;
  apdexByProjectId[action.projectId] = action.apdex;

  final apdexBeforeByProjectId = state.apdexBeforeByProjectId;
  apdexBeforeByProjectId[action.projectId] = action.apdexBefore;

  return state.copyWith(
    apdexByProjectId: apdexByProjectId,
    apdexBeforeByProjectId: apdexBeforeByProjectId
  );
}

GlobalState _bookmarkProjectSuccessAction(GlobalState state, BookmarkProjectSuccessAction action) {
  final projectsByOrganizationSlug = <String, List<Project>>{};
  final projects = <Project>[];

  for (final project in state.projects) {
    if (project.id == action.project.id) {
      projects.add(action.project);
    } else {
      projects.add(project);
    }
  }

  for (final organizationSlug in state.projectsByOrganizationSlug.keys) {
    final projects = <Project>[];
    for (final project in state.projectsByOrganizationSlug[organizationSlug]) {
      if (project.id == action.project.id) {
        projects.add(action.project);
      } else {
        projects.add(project);
      }
    }
    projectsByOrganizationSlug[organizationSlug] = projects;
  }

  projects.sort((Project a, Project b) {
    return (a.slug ?? a.name).toLowerCase().compareTo((b.slug ?? b.name).toLowerCase());
  });
  projects.sort((Project a, Project b) {
    final valueA = a.isBookmarked ? 0 : 1;
    final valueB = b.isBookmarked ? 0 : 1;
    return valueA.compareTo(valueB);
  });

  return state.copyWith(
      projectsByOrganizationSlug: projectsByOrganizationSlug,
      projects: projects
  );
}

GlobalState _apiFailureAction(GlobalState state, ApiFailureAction action) {
  final error = action.error;
  if (error is ApiError && error.statusCode == 401) {
    return _logoutAction(state, LogoutAction());
  } else {
    return state;
  }
}

// -----------------------------
