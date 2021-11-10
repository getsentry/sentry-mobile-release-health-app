library after_layout;

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

mixin SentryStateTransactionMixin<T extends StatefulWidget> on State<T> {
  ISentrySpan? transaction;

  @override
  void initState() {
    super.initState();
    transaction = Sentry.startTransaction(
      transactionName(),
      'ui.load',
      bindToScope: true,
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      transaction?.status ??= SpanStatus.ok();
      transaction?.finish();
    });
  }

  /// Per default this method returns `runtimeType.toString()`. Override to
  /// provide a custom transaction name.
  String transactionName() {
    return runtimeType.toString();
  }
}
