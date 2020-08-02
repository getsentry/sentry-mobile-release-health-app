import 'package:flutter/material.dart';

import 'app_bar.dart';

class ReleaseHealth extends StatefulWidget {
  const ReleaseHealth({Key key}) : super(key: key);

  @override
  _ReleaseHealthState createState() => _ReleaseHealthState();
}

class _ReleaseHealthState extends State<ReleaseHealth> {
  @override
  Widget build(BuildContext context) {
    return SentryAppBar(Container(
      child: Column(
        children: [
          Text('release..'),
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
