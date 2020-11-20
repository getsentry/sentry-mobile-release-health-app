import 'package:redux/redux.dart';

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
  TypedReducer<GlobalState, FetchOrganizationsSuccessAction>(_fetchOrganizationsSuccessAction),
  TypedReducer<GlobalState, SelectOrganizationAction>(_selectOrganizationAction),
  TypedReducer<GlobalState, FetchProjectsSuccessAction>(_fetchProjectSuccessAction),
  TypedReducer<GlobalState, SelectProjectAction>(_selectProjectAction),
  TypedReducer<GlobalState, FetchReleasesAction>(_fetchReleasesAction),
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

GlobalState _fetchOrganizationsSuccessAction(GlobalState state, FetchOrganizationsSuccessAction action) {
  return state.copyWith(organizations: action.payload);
}

GlobalState _selectOrganizationAction(GlobalState state, SelectOrganizationAction action) {
  return state.copyWith(selectedOrganization: action.payload);
}

GlobalState _fetchProjectSuccessAction(GlobalState state, FetchProjectsSuccessAction action) {
  return state.copyWith(projects: action.payload);
}

GlobalState _selectProjectAction(GlobalState state, SelectProjectAction action) {
  return state.copyWith(selectedProject: action.payload);
}

GlobalState _fetchReleasesAction(GlobalState state, FetchReleasesAction action) {
  return state.copyWith(releasesLoading: true);
}

GlobalState _fetchReleasesSuccessAction(GlobalState state, FetchReleasesSuccessAction action) {
  return state.copyWith(releases: action.payload, releasesLoading: false);
}

GlobalState _fetchReleasesFailureAction(GlobalState state, FetchReleasesFailureAction action) {
  return state.copyWith(releasesLoading: false);
}

// -----------------------------
