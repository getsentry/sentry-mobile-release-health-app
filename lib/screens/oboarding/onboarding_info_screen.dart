
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
          Expanded(
            flex: 1,
            child: Image.asset('assets/sitting-logo.jpg')
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  'Before we start...',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                LinkRichText(
                    'Sentry Mobile is still early access software, focused on Release Health. To use the rest of Sentry\'s features, please use ',
                    'https://www.sentry.io/',
                    'sentry.io',
                    ' instead.',
                    Theme.of(context).textTheme.subtitle1
                )
              ]
            )
          )
        ],
        )
    ,
    );
  }}