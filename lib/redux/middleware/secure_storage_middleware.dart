import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../state/app_state.dart';

class SecureStorageMiddleware extends MiddlewareClass<AppState> {
  SecureStorageMiddleware(this.secureStorage);

  final FlutterSecureStorage secureStorage;

  static const _keyAuthToken = 'authToken';
  static const _keySentrySdkEnabled = 'sentrySdkEnabled';

  static Future<bool> sentrySdkEnabled(
      FlutterSecureStorage secureStorage) async {
    final String? sentrySdkEnabledValue =
        await secureStorage.read(key: _keySentrySdkEnabled);
    return sentrySdkEnabledValue == 'true';
  }

  @override
  dynamic call(
      Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String? authToken = await secureStorage.read(key: _keyAuthToken);

      final packageInfo = await PackageInfo.fromPlatform();
      final version =
          'Version ${packageInfo.version} (${packageInfo.buildNumber})';

      store.dispatch(RehydrateSuccessAction(
        authToken,
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
