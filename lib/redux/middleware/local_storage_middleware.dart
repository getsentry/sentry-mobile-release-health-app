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
      final packageInfo = await PackageInfo.fromPlatform();
      final version = 'Version ${packageInfo.version} (${packageInfo.buildNumber})';
      store.dispatch(RehydrateSuccessAction(authToken, version));
      if (authToken != null) {
        store.dispatch(FetchAuthenticatedUserAction());
      }
    }
    if (action is LoginSuccessAction) {
      await secureStorage.write(key: 'authToken', value: action.authToken);
      store.dispatch(FetchAuthenticatedUserAction());
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: 'authToken');
      await preferences.clear();
    }
    next(action);
  }
}
