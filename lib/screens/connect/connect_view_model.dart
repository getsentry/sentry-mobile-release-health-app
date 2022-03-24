import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../api/sentry_api.dart';
import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/auth_token_code.dart';

class ConnectViewModel {
  ConnectViewModel(this.store);
  factory ConnectViewModel.fromStore(Store<AppState> store) {
    return ConnectViewModel(store);
  }

  Store<AppState> store;

  Future<void> onTokenEncoded(String? encoded) async {
    if (encoded == null) {
      return;
    }
    try {
      final decoded = utf8.decode(base64.decode(encoded));
      final json = jsonDecode(decoded) as Map<String, dynamic>;
      final authTokenCode = AuthTokenCode.fromJson(json);
      return onToken(authTokenCode.authToken);
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> onToken(String? token) async {
    if (token == null) {
      return;
    }
    try {
      final sentryApi = SentryApi(token);
      await sentryApi.organizations(); // Do a sample call
      sentryApi.close();
      store.dispatch(LoginSuccessAction(token));
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      rethrow;
    }
  }
}
