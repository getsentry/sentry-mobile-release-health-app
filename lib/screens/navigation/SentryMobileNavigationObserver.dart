import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryMobileRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  ISentrySpan? _transaction;
  Timer? _idleTimer;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _finishTransaction();
    _startTransaction(route.settings.name, route.settings.arguments);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _finishTransaction();
    super.didPop(route, previousRoute);
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

    _idleTimer = Timer(Duration(seconds: 3), () async {
      await _finishTransaction();
    });
  }

  Future<void> _finishTransaction() async {
    _idleTimer?.cancel();
    _transaction?.status ??= SpanStatus.ok();
    return await _transaction?.finish();
  }
}
