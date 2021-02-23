import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class SentrySdkMiddleware extends MiddlewareClass<AppState> {

  @override
  dynamic call(Store<AppState> store, action, next) {
    if (action is ApiFailureAction) {
      Sentry.captureException(action.error);
    }
    next(action);
  }
  
}
