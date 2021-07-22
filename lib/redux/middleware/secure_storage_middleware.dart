import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/rating/rating_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';
import '../state/app_state.dart';

class SecureStorageMiddleware extends MiddlewareClass<AppState> {
  SecureStorageMiddleware(this.secureStorage);

  final FlutterSecureStorage secureStorage;

  final _keyAuthToken = 'authToken';
  final _keySentrySdkEnabled = 'sentrySdkEnabled';

  @override
  dynamic call(
      Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String? authToken = await secureStorage.read(key: _keyAuthToken);

      final String? sentrySdkEnabledValue =
          await secureStorage.read(key: _keySentrySdkEnabled);
      final bool sentrySdkEnabled = sentrySdkEnabledValue == 'true';

      final packageInfo = await PackageInfo.fromPlatform();
      final version =
          'Version ${packageInfo.version} (${packageInfo.buildNumber})';

      store.dispatch(RehydrateSuccessAction(
        authToken,
        sentrySdkEnabled,
        version,
      ));
      if (authToken != null) {
        store.dispatch(FetchAuthenticatedUserAction(authToken));
      }
    }
    if (action is SentrySdkToggleAction) {
      if (action.enabled) {
        await secureStorage.write(key: _keySentrySdkEnabled, value: 'true');
      } else {
        await secureStorage.delete(key: _keySentrySdkEnabled);
      }
    }
    if (action is LoginSuccessAction) {
      await secureStorage.write(key: _keyAuthToken, value: action.authToken);
      store.dispatch(FetchAuthenticatedUserAction(action.authToken));
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: _keyAuthToken);
      await secureStorage.delete(key: _keySentrySdkEnabled);
    }
    next(action);
  }

  // Rating

}
