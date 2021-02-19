
import 'dart:convert';
import 'dart:io';

import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_mobile/api/sentry_api.dart';
import 'package:sentry_mobile/types/auth_token_code.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class ConnectViewModel {
  ConnectViewModel(this.store);
  factory ConnectViewModel.fromStore(Store<AppState> store) {
    return ConnectViewModel(store);
  }

  Store<AppState> store;

  Future<void> onScanned(String encoded) async {
    try {
      final decoded = utf8.decode(base64.decode(encoded));
      final json = jsonDecode(decoded) as Map<String, dynamic>;
      final authTokenCode = AuthTokenCode.fromJson(json);
      final sentryApi = SentryApi(authTokenCode.authToken);
      await sentryApi.organizations();

      store.dispatch(LoginAction(authTokenCode.authToken));
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }
}
