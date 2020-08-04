import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_mobile/types/organization.dart';

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
  GlobalState({this.organizations, this.session, this.storage});

  factory GlobalState.initial() {
    return GlobalState(
        organizations: [],
        session: null,
        storage: FlutterSecureStorage()
    );
  }

  final List<Organization> organizations;
  final FlutterSecureStorage storage;
  final Cookie session;

  GlobalState copyWith({
    List<Organization> organizations,
    Cookie session,
    bool setSessionNull = false,
    FlutterSecureStorage storage,
  }) {
    return GlobalState(
      organizations: organizations ?? this.organizations,
      session: setSessionNull ? null: (session ?? this.session),
      storage: storage ?? this.storage,
    );
  }

}
