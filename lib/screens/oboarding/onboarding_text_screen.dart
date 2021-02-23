
import 'package:flutter/material.dart';

import '../../screens/shared/link_rich_text.dart';

class OnboardingInfoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox()
          )
        ]
      )
    ,
    );
  }}