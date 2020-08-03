import 'dart:io';

import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

class LoginViewModel {
  LoginViewModel({this.session, this.login, this.logout});

  final Cookie session;
  final Function(Cookie session) login;
  final Function() logout;

  static LoginViewModel fromStore(Store<AppState> store) => LoginViewModel(
      session: store.state.globalState.session,
      login: (Cookie session) {
        store.dispatch(LoginAction(session));
        store.state.globalState.storage
            .write(key: 'session', value: session.toString());
        print(session);
      },
      logout: () {
        print('LOGOUT');
        store.dispatch(LogoutAction());
        store.state.globalState.storage.delete(key: 'session');
      });
}
