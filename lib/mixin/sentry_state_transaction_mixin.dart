library after_layout;

import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

mixin SentryStateTransactionMixin<T extends StatefulWidget> on State<T> {
  ISentrySpan? transaction;

  /// Per default this method returns `runtimeType.toString()`. Override to
  /// provide a custom transaction name.
  String transactionName() {
    return runtimeType.toString();
  }

  @override
  void initState() {
    super.initState();
    transaction = Sentry.startTransaction(
      transactionName(),
      'ui.load',
      bindToScope: true,
    );
    // When Flutter executes the initState() method, it is in the middle of a
    // frame rendering process. Once the frame is rendered (after build),
    // the callback executes.
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      transaction?.status ??= SpanStatus.ok();
      transaction?.finish();
    });
  }
}
