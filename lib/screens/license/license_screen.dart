import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

class LicenseScreen extends StatelessWidget {
  LicenseScreen(this.applicationVersion);
  final String applicationVersion;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Theme(
        data: themeData.copyWith(
          textTheme: themeData.textTheme.copyWith(
            subtitle1: TextStyle(
              fontSize: 16,
              color: SentryColors.revolver,
            ),
          ),
        ),
        child: LicensePage(
          applicationName: 'Sentry Mobile',
          applicationVersion: applicationVersion,
        ));
  }
}
