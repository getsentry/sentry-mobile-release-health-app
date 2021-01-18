
import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

class OnboardingDetailScreen extends StatelessWidget {
  OnboardingDetailScreen(this._headline, this._subtitle);

  final String _headline;
  final String _subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32, top: 64, right: 32, bottom: 64),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            height: 256,
            width: 256,
            decoration: BoxDecoration(
                color: SentryColors.mamba,
                borderRadius: BorderRadius.all(Radius.circular(128))),
          ),
          SizedBox(height: 32),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _headline,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center
              ),
              SizedBox(height: 12),
              Text(
                _subtitle,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center
              ),
            ],
          )
        ]
      )
    );
  }
}