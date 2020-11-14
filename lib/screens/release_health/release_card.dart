import 'package:flutter/material.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/release.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard({@required this.project, @required this.release, @required this.index});

  final Project project;
  final Release release;
  final int index; // TODO: hardcoded for demo purposes

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 20),
        elevation: 4,
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
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 16),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.version,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.project,
                  style: TextStyle(
                    color: Color(0xB3ffffff),
                    fontSize: 14
                  ),
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
