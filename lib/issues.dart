import 'package:flutter/material.dart';

class Issues extends StatefulWidget {
  const Issues({Key key}) : super(key: key);

  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text('issues..'),
        ],
      ),
    );
  }
}
