import 'package:flutter/material.dart';

import 'issues.dart';
import 'login.dart';
import 'release_health.dart';

class SentryAppBar extends StatelessWidget {
  SentryAppBar(this.body, {Key key}) : super(key: key);
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentry'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_open),
            onPressed: () {
              Navigator.push<Login>(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
              Navigator.push<Issues>(
                context,
                MaterialPageRoute(builder: (context) => Issues()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.healing),
            onPressed: () {
              Navigator.push<ReleaseHealth>(
                context,
                MaterialPageRoute(builder: (context) => ReleaseHealth()),
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
