import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class SentrySdkMiddleware extends MiddlewareClass<AppState> {

  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is ApiFailureAction) {
      Sentry.captureException(action.error, stackTrace: action.stackTrace);
    }
    if (action is FetchAuthenticatedUserSuccessAction) {
      Sentry.configureScope((scope) => scope.user = User(email: action.me.email, id: action.me.id, ipAddress: "{{auto}}"));
    }
    if (action is LogoutAction) {
      Sentry.configureScope((scope) => scope.user = null);
    }
    next(action);
  }
}
