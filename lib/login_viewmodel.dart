import 'dart:io';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

class LoginViewModel {
  final Function(Cookie session) login;

  LoginViewModel(
      {this.login});

  static LoginViewModel fromStore(Store<AppState> store) => LoginViewModel(
    login: (Cookie session) {
      store.dispatch(LoginAction(session));
      store.state.globalState.storage.write(key: 'session', value: session.toString());
      print(session);
        },
      );
}
