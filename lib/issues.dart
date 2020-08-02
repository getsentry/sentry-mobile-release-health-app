import 'package:flutter/material.dart';
import 'app_bar.dart';

class Issues extends StatefulWidget {
  const Issues({Key key}) : super(key: key);

  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  @override
  Widget build(BuildContext context) {
    return SentryAppBar(Container(
      child: Column(
        children: [
          const Text('issues..'),
          Row(children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text('Back route'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
        ],
      ),
    ));
  }
}
