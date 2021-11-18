
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryMobileRouteObserver extends RouteObserver<PageRoute<dynamic>> {

  ISentrySpan? _transaction;

  @override
  void didPush(Route route, Route? previousRoute) {
    _finishTransaction();
    _startTransaction(route.settings.name, route.settings.arguments);
    super.didPush(route, previousRoute);
  }

  void _startTransaction(String? name, Object? arguments) {
    _transaction = Sentry.startTransaction(
      name ?? 'unknown',
      'ui.load',
      bindToScope: true,
    );
    if (arguments != null) {
      _transaction?.setData('route_settings_arguments', arguments);
    }
    Future.delayed(Duration(seconds: 2), () async {
      await _finishTransaction();
    });
  }

  Future<void> _finishTransaction() async {
    _transaction?.status ??= SpanStatus.ok();
    return await _transaction?.finish();
  }
}
