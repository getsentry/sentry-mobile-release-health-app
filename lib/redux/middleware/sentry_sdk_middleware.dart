import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';

class SentrySdkMiddleware extends MiddlewareClass<AppState> {
  @override
  dynamic call(
    Store<AppState> store,
    dynamic action,
    NextDispatcher next,
  ) async {
    if (action is RehydrateSuccessAction) {
      if (action.sentrySdkEnabled && !Sentry.isEnabled) {
        _enableSentrySdk();
      }
    }
    if (action is SentrySdkToggleAction) {
      if (action.enabled && !Sentry.isEnabled) {
        _enableSentrySdk();
      } else if (!action.enabled && Sentry.isEnabled) {
        _disableSentrySdk();
      }
    }
    if (action is ApiFailureAction) {
      Sentry.captureException(action.error, stackTrace: action.stackTrace);
    }
    if (action is FetchAuthenticatedUserSuccessAction) {
      // https://docs.sentry.io/platforms/flutter/enriching-events/identify-user/
      // Set to auto to let the server decide the IP
      Sentry.configureScope(
        (scope) => scope.user = SentryUser(
          email: action.me.email,
          id: action.me.id,
          ipAddress: '{{auto}}',
        ),
      );
    }
    if (action is LogoutAction) {
      Sentry.configureScope((scope) => scope.user = null);
    }
    next(action);
  }

  Future<void> _enableSentrySdk() async {
    await SentryFlutter.init((options) {
      if (kReleaseMode) {
        options.dsn =
            'https://319565557671403383e51a7e3fae4529@o1.ingest.sentry.io/5645511';
      } else {
        options.dsn =
            'https://b647bf95c35249fe967c91feae3f72d7@o447951.ingest.sentry.io/5555613';
      }

      // This marks every stack trace frame which is not `sentry_mobile`
      // as a not in app frame.
      options.addInAppInclude('sentry_mobile');
      options.considerInAppFramesByDefault = false;
      options.tracesSampleRate = 1.0;
    });
  }

  void _disableSentrySdk() {
    Sentry.close();
  }
}
