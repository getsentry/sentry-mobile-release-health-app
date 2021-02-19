import 'dart:io';

import 'package:redux/redux.dart';
import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class ConnectViewModel {
  ConnectViewModel(this.store);
  factory ConnectViewModel.fromStore(Store<AppState> store) {
    return ConnectViewModel(store);
  }

  Store<AppState> store;

  void onLogin(Cookie session) {
    store.dispatch(LoginAction(session));
  }
}