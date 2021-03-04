import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../utils/sentry_colors.dart';

class OnboardingConsentScreen extends StatelessWidget {
  OnboardingConsentScreen(this.onPressedEnableOrDisable);

  final Function onPressedEnableOrDisable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 4,
              child: Image.asset('assets/reading-logo.jpg')
          ),
          Expanded(
              flex: 3,
              child: Column(
                  children: [
                    Text(
                      'One last thing...',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'We\'re using our own SDK to collect crash reports and session data. That okay with you?',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    RaisedButton(
                      child: const Text('Enable SDK'),
                      textColor: Colors.white,
                      color: SentryColors.rum,
                      onPressed: () async {
                        StoreProvider.of<AppState>(context).dispatch(
                          SentrySdkToggleAction(true)
                        );
                        onPressedEnableOrDisable();
                      },
                    ),
                    FlatButton(
                      child: const Text('Maybe Later'),
                      textColor: SentryColors.rum,
                      onPressed: () {
                        onPressedEnableOrDisable();
                      },
                    ),
                  ]
              )
          )
        ],
      )
      ,
    );
  }
}
