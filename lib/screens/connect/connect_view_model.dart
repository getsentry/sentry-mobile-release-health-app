import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_plus/sentry_plus.dart';

import '../../api/sentry_api.dart';
import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/auth_token_code.dart';

final _decoder =
    json.decoder.fuse(base64.decoder.fuse(utf8.decoder)).wrapWithTraces();

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
      final json = _decoder.convert(encoded) as Map<String, dynamic>;
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
