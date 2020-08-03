import 'package:flutter/material.dart';

class ReleaseHealth extends StatefulWidget {
  const ReleaseHealth({Key key}) : super(key: key);

  @override
  _ReleaseHealthState createState() => _ReleaseHealthState();
}

class _ReleaseHealthState extends State<ReleaseHealth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('release..'),
        ],
      ),
    );
  }
}
