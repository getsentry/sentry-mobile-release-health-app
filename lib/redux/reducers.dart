import 'package:redux/redux.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) =>
    AppState(
      globalState: globalReducer(state.globalState, action),
    );


final globalReducer = combineReducers<GlobalState>([
  TypedReducer<GlobalState, LoginAction>(_loginAction),
  TypedReducer<GlobalState, LogoutAction>(_logoutAction),
  TypedReducer<GlobalState, TitleAction>(_titleAction),
]);

GlobalState _loginAction(GlobalState state, LoginAction action) {
  return state.copyWith(session: action.payload);
}

GlobalState _logoutAction(GlobalState state, LogoutAction action) {
  return state.copyWith(setSessionNull: true);
}

GlobalState _titleAction(GlobalState state, TitleAction action) {
  return state.copyWith(title: action.payload);
}

// -----------------------------
