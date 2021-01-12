import 'package:flutter/material.dart';

import '../../screens/shared/avatar_stack.dart';
import '../../screens/shared/bordered_circle_avatar_view_model.dart';
import '../../types/project.dart';
import '../../types/release.dart';
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _platforms(context, project.platforms),
                    AvatarStack(
                        release?.authors
                          ?.take(5)
                          ?.map((e) => BorderedCircleAvatarViewModel.from(e))
                          ?.toList() ?? [],
                        24,
                        2
                    )
                  ],
                )
              ),
            ]),
          ),
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
