import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../redux/state/session_state.dart';
import '../../types/project.dart';
import '../../types/release.dart';
import '../../utils/platform_icons.dart';
import '../../utils/sentry_colors.dart';
import '../../utils/session_formatting.dart';
import '../chart/line_chart.dart';
import '../chart/line_chart_data.dart';

class ProjectCard extends StatelessWidget {
  ProjectCard(this.organizationName, this.project, this.release, this.sessions);

  final String organizationName;
  final Project project;
  final Release release; // Nullable
  final SessionState sessions; // Nullable

  @override
  Widget build(BuildContext context) {

    final titleRowChildren = <Widget>[
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              project.slug ?? project.name ?? '--',
              maxLines: 2,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      )
    ];


    final platform = project.platform ?? project.platforms.first;
    if (platform != null) {
      final platformImage = PlatformIcons.svgPicture(platform, 20, 20);
      if (platformImage != null) {
        titleRowChildren.add(
            Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      width: 2,
                      color: Colors.white
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    child: platformImage
                  ),
                )
            )
        );
      }
    }

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
                padding: const EdgeInsets.only(left: 16, top: 20, right: 12, bottom: 0),
                child: Row(children: titleRowChildren)
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 0, right: 12, bottom: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      organizationName ?? '--',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child:
                  sessions == null
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
                          data: LineChartData.prepareData(points: sessions.sessionPoints),
                          lineWidth: 5.0,
                          lineColor: Colors.black.withOpacity(0.05),
                          gradientStart: Colors.transparent,
                          gradientEnd: Colors.transparent,
                          cubicLines: false
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LineChart(
                            data: LineChartData.prepareData(points: sessions.sessionPoints),
                            lineWidth: 5.0,
                            lineColor: Colors.white,
                            gradientStart: Colors.transparent,
                            gradientEnd: Colors.transparent,
                            cubicLines: false
                        ),
                      ),
                    ]
                  )
              ),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: viewportConstraints.maxWidth
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 4, right: 12, bottom: 16
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoBox(context, "Total: ${sessions?.numberOfSessions?.formattedNumberOfSession() ?? '--'}"),
                              // if (release?.authors?.isNotEmpty == true)
                              //   SizedBox(width: 6),
                              // AvatarStack(
                              //   release?.authors
                              //     ?.take(5)
                              //     ?.map((e) =>
                              //     BorderedCircleAvatarViewModel.from(e))
                              //     ?.toList() ?? [],
                              //   24,
                              //   2
                              // )
                            ],
                          )
                      ),
                    ),
                  );
              })
            ]),
          ),
        ));
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
