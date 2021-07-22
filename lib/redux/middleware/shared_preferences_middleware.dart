import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';
import '../rating/rating_actions.dart';

class SharedPreferencesMiddleware extends MiddlewareClass<AppState> {
  SharedPreferencesMiddleware(this._preferences);

  final SharedPreferences _preferences;
  final _keyAppStarts = 'appStarts';
  final _keyLastRatingPresentation = 'lastRatingPresentation';

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final appStarts = await _incrementAndReturnAppStarts();
      final lastRatingPresentation = await _lastRatingPresentation();
      store.dispatch(RatingRehydrateAction(appStarts, lastRatingPresentation));
    } else if (action is RatingPresentationAction) {
      await _resetAppStarts();
      await _persistLastRatingPresentation(action.date);
    } else if (action is LogoutAction) {
      await _preferences.clear();
    }
    next(action);
  }

  // Helper

  Future<int> _incrementAndReturnAppStarts() async {
    var appStarts = _preferences.getInt(_keyAppStarts) ?? 0;
    appStarts += 1;
    await _preferences.setInt(_keyAppStarts, appStarts);
    return appStarts;
  }

  Future<void> _resetAppStarts() async {
    await _preferences.setInt(_keyAppStarts, 0);
  }

  Future<DateTime?> _lastRatingPresentation() async {
    final lastRatingPresentation =
        _preferences.getInt(_keyLastRatingPresentation);
    if (lastRatingPresentation == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(lastRatingPresentation);
  }

  Future<bool> _persistLastRatingPresentation(DateTime date) async {
    return _preferences.setInt(
      _keyLastRatingPresentation,
      date.millisecondsSinceEpoch,
    );
  }
}
