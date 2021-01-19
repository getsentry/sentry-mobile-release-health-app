import 'package:redux/redux.dart';

import '../api/api_errors.dart';
import '../types/project_with_latest_release.dart';
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
  TypedReducer<GlobalState, FetchOrganizationsAndProjectsFailureAction>(_fetchOrganizationsAndProjectsFailureAction),
  TypedReducer<GlobalState, FetchLatestReleasesAction>(_fetchLatestReleasesAction),
  TypedReducer<GlobalState, FetchLatestReleasesSuccessAction>(_fetchLatestReleasesSuccessAction),
  TypedReducer<GlobalState, FetchLatestReleasesFailureAction>(_fetchLatestReleasesFailureAction),
  TypedReducer<GlobalState, FetchLatestReleaseSuccessAction>(_fetchLatestReleaseSuccessAction),
  TypedReducer<GlobalState, FetchIssuesSuccessAction>(_fetchIssuesSuccessAction),
  TypedReducer<GlobalState, SelectOrganizationAction>(_selectOrganizationAction),
  TypedReducer<GlobalState, SelectProjectAction>(_selectProjectAction),
  TypedReducer<GlobalState, FetchAuthenticatedUserSuccessAction>(_fetchAuthenticatedUserSuccessAction),
  TypedReducer<GlobalState, FetchSessionsSuccessAction>(_fetchSessionsSuccessAction),
  TypedReducer<GlobalState, ApiFailureAction>(_apiFailureAction),
]);

GlobalState _switchTabAction(GlobalState state, SwitchTabAction action) {
  return state.copyWith(selectedTab: action.selectedTab);
}

GlobalState _rehydrateSuccessAction(GlobalState state, RehydrateSuccessAction action) {
  return state.copyWith(hydrated: true, session: action.cookie);
}

GlobalState _loginAction(GlobalState state, LoginAction action) {
  return state.copyWith(session: action.cookie);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return state.copyWith(
    setSessionNull: true,
    selectedTab: 0,
    organizations: [],
    projectsByOrganizationSlug: {},
    projectsFetchedOnce: false,
    projectsLoading: false,
    projectsWithLatestReleases: [],
    releasesFetchedOnce: false,
    releasesLoading: false,
    handledIssuesByProjectSlug: {},
    unhandledIssuesByProjectSlug: {}
  );
}

GlobalState _fetchOrganizationsAndProjectsAction(GlobalState state, FetchOrganizationsAndProjectsAction action) {
  return state.copyWith(projectsLoading: true);
}

GlobalState _fetchOrganizationsAndProjectsSuccessAction(GlobalState state, FetchOrganizationsAndProjectsSuccessAction action) {
  final organizationsSlugByProjectSlug = <String, String>{};
  final projectsWithLatestReleases = <ProjectWithLatestRelease>[];

  for (final organizationSlug in action.projectsByOrganizationSlug.keys) {
    for (final project in action.projectsByOrganizationSlug[organizationSlug]) {
      organizationsSlugByProjectSlug[project.slug] = organizationSlug;
      if (project.latestRelease != null) {
        projectsWithLatestReleases.add(ProjectWithLatestRelease(project, null));
      }
    }
  }

  return state.copyWith(
    organizations: action.organizations,
    organizationsSlugByProjectSlug: organizationsSlugByProjectSlug,
    projectsByOrganizationSlug: action.projectsByOrganizationSlug,
    projectsWithLatestReleases: projectsWithLatestReleases,
    projectsFetchedOnce: true,
    projectsLoading: false,
    releasesLoading: false
  );
}

GlobalState _fetchOrganizationsAndProjectsFailureAction(GlobalState state, FetchOrganizationsAndProjectsFailureAction action) {
  return state.copyWith(projectsLoading: false);
}

GlobalState _selectOrganizationAction(GlobalState state, SelectOrganizationAction action) {
  return state.copyWith(selectedOrganization: action.organization);
}

GlobalState _selectProjectAction(GlobalState state, SelectProjectAction action) {
  return state.copyWith(selectedProject: action.project);
}

GlobalState _fetchLatestReleasesAction(GlobalState state, FetchLatestReleasesAction action) {
  return state.copyWith(releasesLoading: true);
}

GlobalState _fetchLatestReleasesSuccessAction(GlobalState state, FetchLatestReleasesSuccessAction action) {
  return state.copyWith(
    projectsWithLatestReleases: action.projectsWithLatestReleases,
    releasesFetchedOnce: true,
    releasesLoading: false
  );
}

GlobalState _fetchLatestReleasesFailureAction(GlobalState state, FetchLatestReleasesFailureAction action) {
  return state.copyWith(releasesLoading: false);
}

GlobalState _fetchLatestReleaseSuccessAction(GlobalState state, FetchLatestReleaseSuccessAction action) {
  final projectsWithLatestReleases = state.projectsWithLatestReleases;
  final organizationSlug = state.organizationsSlugByProjectSlug[action.projectSlug];
  final project = state.projectsByOrganizationSlug[organizationSlug].where((element) => element.slug == action.projectSlug).first;

  if (project != null) {
    final index = projectsWithLatestReleases.indexWhere((element) => element.project.id == project.id);
    if (index != -1) {
      projectsWithLatestReleases.removeAt(index);
      projectsWithLatestReleases.insert(index, ProjectWithLatestRelease(project, action.latestRelease));
    } else {
      projectsWithLatestReleases.add(ProjectWithLatestRelease(project, action.latestRelease));
    }
  }
  return state.copyWith(
      projectsWithLatestReleases: projectsWithLatestReleases,
      releasesFetchedOnce: true,
      releasesLoading: false
  );
}

GlobalState _fetchIssuesSuccessAction(GlobalState state, FetchIssuesSuccessAction action) {
  final handledIssuedByProjectSlug = state.handledIssuesByProjectSlug;
  final unhandledIssuesByByProjectSlug = state.unhandledIssuesByProjectSlug;

  if (action.unhandled) {
    unhandledIssuesByByProjectSlug[action.projectSlug] = action.issues;
  } else {
    handledIssuedByProjectSlug[action.projectSlug] = action.issues;
    unhandledIssuesByByProjectSlug[action.projectSlug] = action.issues
        .where((element) => element.type == 'error').toList();
  }

  return state.copyWith(
      handledIssuesByProjectSlug: handledIssuedByProjectSlug,
      unhandledIssuesByProjectSlug: unhandledIssuesByByProjectSlug
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
  return state.copyWith(
      sessionsByProjectId: sessionsByProjectId
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
