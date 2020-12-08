import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/project_with_latest_release.dart';

import 'actions.dart';
import 'state/app_state.dart';

AppState appReducer(AppState state, dynamic action) =>
    AppState(
      globalState: globalReducer(state.globalState, action),
    );

final globalReducer = combineReducers<GlobalState>([
  TypedReducer<GlobalState, SwitchTabAction>(_switchTabAction),
  TypedReducer<GlobalState, RehydrateAction>(_bootAction),
  TypedReducer<GlobalState, LoginAction>(_loginAction),
  TypedReducer<GlobalState, LogoutAction>(_logoutAction),
  TypedReducer<GlobalState, FetchOrganizationsAndProjectsSuccessAction>(_fetchOrganizationsAndProjectsSuccessAction),
  TypedReducer<GlobalState, SelectOrganizationAction>(_selectOrganizationAction),
  TypedReducer<GlobalState, FetchProjectsSuccessAction>(_fetchProjectSuccessAction),
  TypedReducer<GlobalState, SelectProjectAction>(_selectProjectAction),
  TypedReducer<GlobalState, SelectProjectsAction>(_selectProjectsAction),
  TypedReducer<GlobalState, FetchLatestReleasesAction>(_fetchReleasesAction),
  TypedReducer<GlobalState, FetchReleasesSuccessAction>(_fetchReleasesSuccessAction),
  TypedReducer<GlobalState, FetchReleasesFailureAction>(_fetchReleasesFailureAction),
]);

GlobalState _switchTabAction(GlobalState state, SwitchTabAction action) {
  return state.copyWith(selectedTab: action.payload);
}

GlobalState _bootAction(GlobalState state, RehydrateAction action) {
  return state.copyWith(hydrated: true);
}

GlobalState _loginAction(GlobalState state, LoginAction action) {
  return state.copyWith(session: action.payload);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return state.copyWith(setSessionNull: true);
}

GlobalState _fetchOrganizationsAndProjectsSuccessAction(GlobalState state, FetchOrganizationsAndProjectsSuccessAction action) {
  return state.copyWith(organizations: action.organizations, projectsByOrganizationId: action.projectsByOrganizationId);
}

GlobalState _selectOrganizationAction(GlobalState state, SelectOrganizationAction action) {
  return state.copyWith(selectedOrganization: action.organziation);
}

GlobalState _fetchProjectSuccessAction(GlobalState state, FetchProjectsSuccessAction action) {
  final projectsByOrganizationId = state.projectsByOrganizationId;
  projectsByOrganizationId[action.organizationId] = action.projects;
  return state.copyWith(projectsByOrganizationId: projectsByOrganizationId);
}

GlobalState _selectProjectAction(GlobalState state, SelectProjectAction action) {
  final selected = state.selectedOrganizationSlugsWithProjectId;
  if (!selected.contains(action.organizationSlugWithProjectId)) {
    selected.add(action.organizationSlugWithProjectId);
  } else {
    selected.remove(action.organizationSlugWithProjectId);
  }
  return state.copyWith(selectedOrganizationSlugsWithProjectId: selected);
}

GlobalState _selectProjectsAction(GlobalState state, SelectProjectsAction action) {
  return state.copyWith(selectedOrganizationSlugsWithProjectId: action.organizationSlugsWithProjectId.toSet());
}

GlobalState _fetchReleasesAction(GlobalState state, FetchLatestReleasesAction action) {
  return state.copyWith(releasesLoading: true);
}

GlobalState _fetchReleasesSuccessAction(GlobalState state, FetchReleasesSuccessAction action) {
  final latestReleases = state.latestReleases;
  final index = state.latestReleases.indexWhere((element) => element.project.id == action.project.id);
  if (index > -1) {
    latestReleases.removeAt(index);
  }
  latestReleases.add(ProjectWithLatestRelease(action.project, action.release));
  return state.copyWith(latestReleases: latestReleases);
}

GlobalState _fetchReleasesFailureAction(GlobalState state, FetchReleasesFailureAction action) {
  return state.copyWith(releasesLoading: false);
}

// -----------------------------
