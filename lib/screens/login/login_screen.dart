import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/state/app_state.dart';
import '../../utils/sentry_colors.dart';
import 'login_view_model.dart';
import 'login_web_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => LoginViewModel.fromStore(store),
    );
  }

  Widget _content(LoginViewModel viewModel) {
    return Container(
        margin: EdgeInsets.all(32.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Lets get started!',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Login to see your projects.',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                RaisedButton(
                  child: Text('Login'),
                  textColor: Colors.white,
                  color: SentryColors.rum,
                  onPressed: () {
                    setState(() {
                      _navigateAndWaitForSession()
                          .then(viewModel.onLogin)
                          .catchError(_handleLoginFailure);
                    });
                  },
                )
              ],
            )
        )
    );
  }

  void _handleLoginFailure(Object error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Error',
              style: Theme.of(context).textTheme.headline1
          ),
          content: Text(
              'Oops, there is a problem. Please try again later.',
              style: Theme.of(context).textTheme.bodyText1
          ),
          actions: [
            FlatButton(
                key: Key('ok'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok')),
          ],
        );
      }
    );
  }

  Future<Cookie> _navigateAndWaitForSession() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LoginWebView()
      ),
    ) as Result<Cookie>;

    return result != null ? result.asFuture : null;
  }
}