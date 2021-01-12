import 'package:flutter/material.dart';

import '../../types/project.dart';
import '../../types/release.dart';
import '../../utils/relative_date_time.dart';
import '../../utils/sentry_colors.dart';
import '../chart/line_chart.dart';
import '../chart/line_chart_data.dart';
import '../chart/line_chart_point.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard(this.project , this.release);

  final Project project;
  final Release release; // Nullable

  @override
  Widget build(BuildContext context) {

    final List<LineChartPoint> _data = release
        ?.stats24h
        ?.map((stat) => LineChartPoint(stat.timestamp.toDouble(), stat.value.toDouble()))
        ?.toList()
        ?? [];

    return Card(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: SentryColors.rum
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [Colors.white.withAlpha((256 * 0.2).toInt()), Colors.transparent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      release?.version ?? '--',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    release?.project ?? project.name,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              Expanded(
                child:
                  release == null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(
                          minHeight: 5.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                        )
                      )
                    ]
                  )
                  : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: LineChart(
                          data: LineChartData.prepareData(points: _data),
                          lineWidth: 5.0,
                          lineColor: Colors.black.withOpacity(0.05),
                          gradientStart: Colors.transparent,
                          gradientEnd: Colors.transparent
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LineChart(
                            data: LineChartData.prepareData(points: _data),
                            lineWidth: 5.0,
                            lineColor: Colors.white,
                            gradientStart: Colors.transparent,
                            gradientEnd: Colors.transparent
                        ),
                      ),
                    ]
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 16),
                child: _releaseAndPlatform(context, release)
              )
            ]),
          ),
        ));
  }

  Widget _releaseAndPlatform(BuildContext context, Release release) {
    final List<Widget> all = [];

    final date = release?.deploy?.dateFinished ?? release?.dateCreated;
    if (date != null) {
      all.add(_infoBox(context, date.relativeFromNow()));
    }
    final environment = release?.deploy?.environment;
    if (environment != null) {
      all.add(_infoBox(context, environment));
    }

    return Row(children: all);
  }

  Widget _infoBox(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0x33ffffff),
          borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),
      padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      child:
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12
          )
        )
      );
  }
}
