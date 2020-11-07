import 'package:flutter/material.dart';

import 'package:sentry_mobile/types/release.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard({@required this.release, @required this.index});

  final Release release;
  final int index; // TODO: hardcoded for demo purposes

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 10, bottom: 20, left: 0, right: 32),
        elevation: 12,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                colors: index == 0
                    ? [Color(0xf723B480), Color(0x7a23B480)]
                    : [Color(0xffD74177), Color(0xffF3B584)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
          child: Column(children: <Widget>[
            SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                    child: ListTile(
                  title: Text(
                    release.version,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    release.project,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )),
              ],
            ),
            Image.asset('assets/line-flat.png'),
          ]),
        ));
  }
}
