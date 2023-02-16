import 'package:flutter/material.dart';

import '../../screens/shared/link_rich_text.dart';

class OnboardingInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 4, child: Image.asset('assets/sitting-logo.jpg')),
          Expanded(
              flex: 3,
              child: Column(children: [
                Text(
                  'Before we start...',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                LinkRichText(
                  Uri.parse('https://www.sentry.io/'),
                  'sentry.io',
                  prefix:
                      'Sentry Mobile is available only to the cool folks, our Early Adopters. We\'re starting out with Release Health. For other Sentry features, please use ',
                  suffix:
                      '.\n\nFeatures available to Early Adopters are still in progress and may have bugs. We recognize the irony.',
                  textStyle: Theme.of(context).textTheme.subtitle1,
                )
              ]))
        ],
      ),
    );
  }
}
