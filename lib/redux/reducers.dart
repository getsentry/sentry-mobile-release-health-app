import 'package:redux/redux.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/types/organization.dart';

AppState appReducer(AppState state, dynamic action) =>
    AppState(
      globalState: globalReducer(state.globalState, action),
    );


final globalReducer = combineReducers<GlobalState>([
  TypedReducer<GlobalState, LoginAction>(_loginAction),
  TypedReducer<GlobalState, LogoutAction>(_logoutAction),
  TypedReducer<GlobalState, FetchOrganizationsSuccessAction>(_fetchOrganizationsSuccessActionAction),
]);

GlobalState _loginAction(GlobalState state, LoginAction action) {
  return state.copyWith(session: action.payload);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return state.copyWith(setSessionNull: true);
}

GlobalState _fetchOrganizationsSuccessActionAction(GlobalState state, FetchOrganizationsSuccessAction action) {
  return state.copyWith(organizations: action.payload.map((dynamic r) => Organization.fromJson(r)).toList());
}

// -----------------------------
