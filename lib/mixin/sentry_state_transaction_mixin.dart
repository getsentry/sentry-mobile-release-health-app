
library after_layout;

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

mixin SentryStateTransactionMixin<T extends StatefulWidget> on State<T> {

  ISentrySpan? transaction;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      transaction = Sentry.startTransaction(
        runtimeType.toString(),
        'ui.load',
        bindToScope: true,
      );
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        transaction?.finish();
      });
    }
  }
}
