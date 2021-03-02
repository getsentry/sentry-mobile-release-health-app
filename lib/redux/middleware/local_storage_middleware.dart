import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';
import '../state/app_state.dart';

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  LocalStorageMiddleware(this.preferences, this.secureStorage);

  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;

  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String authToken = await secureStorage.read(key: 'authToken');

      final String sdkEnabledValue = await secureStorage.read(key: 'sdkEnabled');
      final bool sdkEnabled = sdkEnabledValue == 'true';

      final packageInfo = await PackageInfo.fromPlatform();
      final version = 'Version ${packageInfo.version} (${packageInfo.buildNumber})';

      store.dispatch(RehydrateSuccessAction(authToken, sdkEnabled, version));
      if (authToken != null) {
        store.dispatch(FetchAuthenticatedUserAction());
      }
    }
    if (action is SdkToggle) {
      if (action.enabled) {
        await secureStorage.write(key: 'sdkEnabled', value: 'true');
      } else {
        await secureStorage.delete(key: 'sdkEnabled');
      }
    }
    if (action is LoginSuccessAction) {
      await secureStorage.write(key: 'authToken', value: action.authToken);
      store.dispatch(FetchAuthenticatedUserAction());
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: 'authToken');
      await secureStorage.delete(key: 'sdkEnabled');
      await preferences.clear();
    }
    next(action);
  }
}
