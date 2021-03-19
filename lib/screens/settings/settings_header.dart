// @dart=2.9

import 'package:flutter/material.dart';

import '../../utils/sentry_colors.dart';

class SettingsHeader extends StatelessWidget {
  SettingsHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: SentryColors.mamba,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
