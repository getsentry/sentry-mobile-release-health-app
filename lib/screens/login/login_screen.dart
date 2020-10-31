import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/login/login_view_model.dart';
import 'package:sentry_mobile/screens/login/login_web_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var _loading = false;

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
                if (!_loading)
                  RaisedButton(
                    child: Text('SignIn'),
                    textColor: Colors.white,
                    color: Color(0xff4e3fb4),
                    onPressed: () {
                      setState(() {
                        final sessionFuture = _navigateAndWaitForSession();
                        sessionFuture.then((session) => viewModel.onLogin(session));
                      });
                    },
                  )
                else
                  CircularProgressIndicator(
                    backgroundColor: Color(0xff4e3fb4),
                  )
              ],
            )
        )
    )
    );
  }

  Future<Cookie> _navigateAndWaitForSession() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => LoginWebView()
      ),
    );
    return result as Cookie;
  }
}