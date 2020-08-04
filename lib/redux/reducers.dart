import 'package:redux/redux.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

AppState appReducer(AppState state, dynamic action) =>
    AppState(
      globalState: globalReducer(state.globalState, action),
    );


final globalReducer = combineReducers<GlobalState>([
  TypedReducer<GlobalState, LoginAction>(_loginAction),
  TypedReducer<GlobalState, LogoutAction>(_logoutAction),
  TypedReducer<GlobalState, FetchOrganizationsSuccessAction>(_fetchOrganizationsSuccessAction),
  TypedReducer<GlobalState, SelectOrganizationAction>(_selectOrganizationAction),
  TypedReducer<GlobalState, FetchProjectsSuccessAction>(_fetchProjectSuccessAction),
  TypedReducer<GlobalState, SelectProjectAction>(_selectProjectAction),
]);

GlobalState _loginAction(GlobalState state, LoginAction action) {
  return state.copyWith(session: action.payload);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return state.copyWith(setSessionNull: true);
}

GlobalState _fetchOrganizationsSuccessAction(GlobalState state, FetchOrganizationsSuccessAction action) {
  final orgs = action.payload.map((dynamic r) => Organization.fromJson(r)).toList();
  return state.copyWith(organizations: orgs, selectedOrganization: orgs.first);
}

GlobalState _selectOrganizationAction(GlobalState state, SelectOrganizationAction action) {
  return state.copyWith(selectedOrganization: action.payload);
}

GlobalState _fetchProjectSuccessAction(GlobalState state, FetchProjectsSuccessAction action) {
  final projs = action.payload.map((dynamic r) => Project.fromJson(r)).toList();
  return state.copyWith(projects: projs, selectedProject: projs.first);
}

GlobalState _selectProjectAction(GlobalState state, SelectProjectAction action) {
  return state.copyWith(selectedProject: action.payload);
}

// -----------------------------
