import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:sentry_mobile/screens/chart/LineChart.dart';
import '../../types/project.dart';
import '../../types/release.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard(this.project , this.release);

  final Project project;
  final Release release;

  @override
  Widget build(BuildContext context) {

    var _data = release
        .stats24h
        .map((stat) => Point(stat.timestamp.toDouble(), stat.value.toDouble()))
        .toList();

    // var _data = [
    //   Point(1607698800,0),
    //   Point(1607702400,0),
    //   Point(1607706000,0),
    //   Point(1607709600,0),
    //   Point(1607713200,0),
    //   Point(1607716800,0),
    //   Point(1607720400,0),
    //   Point(1607724000,0),
    //   Point(1607727600,0),
    //   Point(1607731200,0),
    //   Point(1607734800,0),
    //   Point(1607738400,0),
    //   Point(1607742000,0),
    //   Point(1607745600,0),
    //   Point(1607749200,0),
    //   Point(1607752800,0),
    //   Point(1607756400,0),
    //   Point(1607760000,0),
    //   Point(1607763600,0),
    //   Point(1607767200,0),
    //   Point(1607770800,0),
    //   Point(1607774400,0),
    //   Point(1607778000,0),
    //   Point(1607781600,0)
    // ];

    return Card(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Color(0xff23B480), Color(0xff23B480)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.version,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.project,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            Expanded(
              child: LineChart(_data, 5.0, Colors.white, Colors.transparent)
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 16),
              child: _platforms(context, project.platforms)
            )
          ]),
        ));
  }

  Widget _platforms(BuildContext context, List<String> platforms) {
    final platformWidgets = platforms.take(3).map((item) => _platform(context, item)).toList();
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
