
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/chart/bar/bar_chart.dart';
import 'package:sentry_mobile/screens/chart/bar/bar_chart_options.dart';
import 'package:sentry_mobile/screens/chart/chart_data.dart';
import 'package:sentry_mobile/screens/chart/chart_entry.dart';
import 'package:sentry_mobile/screens/chart/line/line_chart.dart';
import 'package:sentry_mobile/screens/health/health_card.dart';
import 'package:sentry_mobile/screens/platform/platform_image.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

import '../chart/line/line_chart_options.dart';
import 'project_details_view_model.dart';

class ProjectDetails extends StatefulWidget {

  ProjectDetails(this.projectId);
  final String projectId;

  @override
  State<StatefulWidget> createState() {
    return _ProjectDetailsState(projectId);
  }

}

class _ProjectDetailsState extends State<ProjectDetails> {

  _ProjectDetailsState(this.projectId);
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProjectDetailsViewModel>(
      converter: (store) => ProjectDetailsViewModel.from(projectId, store),
      builder: (_, viewModel) => _content(viewModel)
    );
  }

  Widget _content(ProjectDetailsViewModel viewModel) {

    final buttonStyle = OutlinedButton.styleFrom(
      primary: SentryColors.whisper,
      backgroundColor: SentryColors.rum,
      textStyle: const TextStyle(fontSize: 13),
    );

    return Scaffold(
        appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(viewModel.title),
              PlatformImage(viewModel.platform, 3),
            ]
          )
        ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HealthCard(
                  title: 'Crash Free Sessions',
                  viewModel: viewModel
                      .crashFreeSessions(),
                ),
                SizedBox(width: 8),
                HealthCard(
                  title: 'Crash Free Users',
                  viewModel:
                  viewModel.crashFreeUsers(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: SentryColors.snuff, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              shadowColor: Colors.transparent,
              child: Container(
                height: 192,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                        child: LineChart(
                          dummyLineChartData,
                          options: LineChartOptions(
                            lineWidth: 2.0,
                            lineColor: SentryColors.buttercup,
                            gradientStart: SentryColors.buttercup.withOpacity(0.5),
                            gradientEnd: SentryColors.buttercup.withOpacity(0.1),
                            cubicLines: true,
                          ),
                        ),
                      )
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SentryColors.snuff,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: SentryColors.whisper,
                      ),
                      padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: buttonStyle,
                            onPressed: () {},
                            child: const Text('Crash Free Sessions'),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Sessions',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '339',
                                  style: TextStyle(
                                    color: SentryColors.revolver,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),

                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: SentryColors.snuff, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0)
              ),
              shadowColor: Colors.transparent,
              child: Container(
                height: 192,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
                          child: BarChart(
                            dummyBarChartData,
                            options: BarChartOptions(
                              barColor: SentryColors.burntSienna,
                              barWidth: 0.9,
                            ),
                          ),
                        )
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SentryColors.snuff,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: SentryColors.whisper,
                      ),
                      padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: buttonStyle,
                            onPressed: () {},
                            child: const Text('Number of Sessions'),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Sessions',
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '1023',
                                  style: TextStyle(
                                    color: SentryColors.revolver,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),

                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  ChartData dummyLineChartData = ChartData.prepareData(
    points: [
      ChartEntry(0, 100),
      ChartEntry(1, 100),
      ChartEntry(2, 100),
      ChartEntry(3, 100),
      ChartEntry(4, 100),
      ChartEntry(5, 100),
      ChartEntry(6, 100),
      ChartEntry(7, 100),
      ChartEntry(8, 100),
      ChartEntry(9, 100),
      ChartEntry(10, 97),
      ChartEntry(11, 96),
      ChartEntry(12, 90),
      ChartEntry(13, 82),
      ChartEntry(14, 80),
      ChartEntry(15, 99),
      ChartEntry(16, 100),
      ChartEntry(17, 100),
      ChartEntry(18, 100),
      ChartEntry(19, 100),
      ChartEntry(20, 100),
      ChartEntry(21, 100),
      ChartEntry(22, 100),
      ChartEntry(23, 100),
    ],
    preferredMinY: 0,
    preferredMaxY: 100
  );

  ChartData dummyBarChartData = ChartData.prepareData(
      points: [
        ChartEntry(0, 20),
        ChartEntry(1, 50),
        ChartEntry(2, 5),
        ChartEntry(3, 100),
        ChartEntry(4, 100),
        ChartEntry(5, 20),
        ChartEntry(6, 30),
        ChartEntry(7, 11),
        ChartEntry(8, 2),
        ChartEntry(9, 9),
        ChartEntry(10, 10),
      ],
      preferredMinY: 0,
      preferredMaxY: 100
  );
}
