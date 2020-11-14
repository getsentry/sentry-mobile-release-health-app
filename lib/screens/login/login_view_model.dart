
import 'dart:io';

import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

class LoginViewModel {
  LoginViewModel(this.store);
  factory LoginViewModel.fromStore(Store<AppState> store) {
    return LoginViewModel(store);
  }

  Store<AppState> store;

  void onLogin(Cookie session) {
    store.dispatch(LoginAction(session));
  }
}