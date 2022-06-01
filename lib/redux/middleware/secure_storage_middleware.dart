import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

import '../actions.dart';
import '../state/app_state.dart';

class SecureStorageMiddleware extends MiddlewareClass<AppState> {
  SecureStorageMiddleware(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  final _keyAuthToken = 'authToken';
  final _keySentrySdkEnabled = 'sentrySdkEnabled';

  Future<bool> sentrySdkEnabled() async {
    final String? sentrySdkEnabledValue =
        await _secureStorage.read(key: _keySentrySdkEnabled);
    return sentrySdkEnabledValue == 'true';
  }

  @override
  dynamic call(
      Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String? authToken = await _secureStorage.read(key: _keyAuthToken);

      final sentrySdkEnabled = await this.sentrySdkEnabled();

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
        await _secureStorage.write(key: _keySentrySdkEnabled, value: 'true');
      } else {
        await _secureStorage.delete(key: _keySentrySdkEnabled);
      }
    }
    if (action is LoginSuccessAction) {
      await _secureStorage.write(key: _keyAuthToken, value: action.authToken);
      store.dispatch(FetchAuthenticatedUserAction(action.authToken));
    }
    if (action is LogoutAction) {
      await _secureStorage.delete(key: _keyAuthToken);
      await _secureStorage.delete(key: _keySentrySdkEnabled);
    }
    next(action);
  }

  // Rating

}
