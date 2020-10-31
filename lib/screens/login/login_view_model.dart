
import 'dart:io';

import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

class LoginViewModel {
  LoginViewModel(this.store);
  Store<AppState> store;

  static LoginViewModel fromStore(Store<AppState> store) =>
      LoginViewModel(store);

  void onLogin(Cookie session) {
    store.dispatch(LoginAction(session));
  }
}