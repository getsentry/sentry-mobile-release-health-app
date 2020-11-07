import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/login/login_view_model.dart';
import 'package:sentry_mobile/screens/login/login_web_view.dart';
import 'package:async/async.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        margin: EdgeInsets.all(22.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    'Working Code, Happy Customers',
                    style: Theme.of(context).textTheme.headline1
                ),
                RaisedButton(
                  child: Text('SignIn'),
                  textColor: Colors.white,
                  color: Color(0xff4e3fb4),
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
    return result.asFuture;
  }
}