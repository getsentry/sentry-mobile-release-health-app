import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppState {
  AppState({this.globalState});

  factory AppState.initial() {
    return AppState(
      globalState: GlobalState.initial(),
    );
  }

  final GlobalState globalState;

  AppState copyWith({GlobalState globalState}) {
    return AppState(
      globalState: globalState ?? this.globalState,
    );
  }
}

class GlobalState {
  GlobalState({this.title, this.session, this.storage});

  factory GlobalState.initial() {
    return GlobalState(
        title: 'Sentry',
        session: null,
        storage: FlutterSecureStorage()
    );
  }

  final String title;
  final FlutterSecureStorage storage;
  final Cookie session;

  GlobalState copyWith({
    String title,
    Cookie session,
    FlutterSecureStorage storage,
  }) {
    return GlobalState(
      title: title ?? this.title,
      session: session ?? this.session,
      storage: storage ?? this.storage,
    );
  }

}
