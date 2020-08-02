import 'package:flutter/material.dart';

import 'app_bar.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SentryAppBar(Container(
      child: Column(
        children: [
          const Text('login..'),
          Center(
            child: RaisedButton(
              child: Text('Back route'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ));
  }
}
