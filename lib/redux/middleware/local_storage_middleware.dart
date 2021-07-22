import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/rating/rating_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';
import '../state/app_state.dart';

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  LocalStorageMiddleware(this.preferences, this.secureStorage);

  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;

  final _keyAuthToken = 'authToken';
  final _keySentrySdkEnabled = 'sentrySdkEnabled';

  final _keyAppStarts = 'appStarts';
  final _keyLastRatingPresentation = 'lastRatingPresentation';

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
          authToken, sentrySdkEnabled, version,));

      final appStarts = await _incrementAndReturnAppStarts();
      final lastRatingPresentation = await _lastRatingPresentation();
      store.dispatch(RatingRehydrateAction(appStarts, lastRatingPresentation));

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
    if (action is RatingPresentationAction) {
      await _resetAppStarts();
      await _persistLastRatingPresentation(action.date);
    }
    if (action is LoginSuccessAction) {
      await secureStorage.write(key: _keyAuthToken, value: action.authToken);
      store.dispatch(FetchAuthenticatedUserAction(action.authToken));
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: _keyAuthToken);
      await secureStorage.delete(key: _keySentrySdkEnabled);
      await preferences.clear();
    }
    next(action);
  }

  // Rating

  Future<int> _incrementAndReturnAppStarts() async {
    var appStarts = preferences.getInt(_keyAppStarts) ?? 0;
    appStarts += 1;
    await preferences.setInt(_keyAppStarts, appStarts);
    return appStarts;
  }

  Future<void> _resetAppStarts() async {
    await secureStorage.write(key: _keyAppStarts, value: '0');
  }

  Future<DateTime?> _lastRatingPresentation() async {
    final lastRatingPresentation = preferences.getInt(_keyLastRatingPresentation);
    if (lastRatingPresentation == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(lastRatingPresentation);
  }

  Future<bool> _persistLastRatingPresentation(DateTime date) async {
    return preferences.setInt(_keyLastRatingPresentation, date.millisecondsSinceEpoch,);
  }
}
