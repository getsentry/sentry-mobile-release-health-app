import 'package:flutter/material.dart';
import 'package:sentry_mobile/screens/shared/bordered_circular_avatar.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/release.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard({@required this.project, @required this.release});

  final Project project;
  final Release release;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Color(0xf723B480), Color(0x7a23B480)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 16),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.version,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.project,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Spacer(),
              _platforms(context, project.platforms)
            ]),
          ),
        ));
  }

  Widget _platforms(BuildContext context, List<String> platforms) {
    final platformWidgets = platforms.map((item) => _platform(context, item)).toList();
    final List<Widget> all = [];
    for (final platformWidget in platformWidgets) {
      all.add(platformWidget);
      if (platformWidget != platformWidgets.last) {
        all.add(SizedBox(width: 8));
      }
    }
    return Row(children: all);
  }

  Widget _platform(BuildContext context, String platform) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0x33ffffff),
          borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),
      padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      child: Text(
          platform,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12
          )
          )
      );
  }
}
