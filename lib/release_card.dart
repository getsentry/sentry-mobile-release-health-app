import 'package:flutter/material.dart';
import 'package:sentry_mobile/release_health.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard({@required this.release});

  final Release release;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 20, bottom: 5, left: 6, right: 6),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(
                  release.version,
                ),
                subtitle: Text(
                  'Version',
                ),
              )),
              Expanded(
                  child: ListTile(
                title: Text(release.project),
                subtitle: Text('Project'),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(
                  release.issues.toString(),
                ),
                subtitle: Text(
                  'New Issues',
                ),
              )),
              Expanded(
                  child: ListTile(
                title: Text(release.crashes.toString()),
                subtitle: Text('Crashes'),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(release.crashFreeUsers.toString() + '%'),
                subtitle: Text('CF Users'),
              )),
              Expanded(
                  child: ListTile(
                title: Text(release.users24h.toString()),
                subtitle: Text('24h Users'),
              )),
              Expanded(
                  child: ListTile(
                title: Text(release.usersTotal.toString()),
                subtitle: Text('Users'),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text(release.crashFreeUsers.toString() + '%'),
                subtitle: Text('CF Sessions'),
              )),
              Expanded(
                  child: ListTile(
                title: Text(release.users24h.toString()),
                subtitle: Text('24h Sessions'),
              )),
              Expanded(
                  child: ListTile(
                title: Text(release.usersTotal.toString()),
                subtitle: Text('Sessions'),
              )),
            ],
          ),
        ]));
  }
}
