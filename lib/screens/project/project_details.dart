
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/chart/line_chart.dart';
import 'package:sentry_mobile/screens/chart/line_chart_data.dart';
import 'package:sentry_mobile/screens/chart/line_chart_point.dart';
import 'package:sentry_mobile/screens/health/health_card.dart';
import 'package:sentry_mobile/screens/platform/platform_image.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

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
  void initState() {
    super.initState();
    print('will render');
    SchedulerBinding.instance?.addPostFrameCallback((duration) {
      print('did render $duration}');
    });
  }

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
                          data: placeholderData,
                          lineWidth: 2.0,
                          lineColor: SentryColors.buttercup,
                          gradientStart: SentryColors.buttercup.withOpacity(0.5),
                          gradientEnd: SentryColors.buttercup.withOpacity(0.1),
                          cubicLines: true,
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
                          child: LineChart(
                            data: placeholderData,
                            lineWidth: 2.0,
                            lineColor: SentryColors.burntSienna,
                            gradientStart: SentryColors.burntSienna.withOpacity(0.5),
                            gradientEnd: SentryColors.burntSienna.withOpacity(0.1),
                            cubicLines: true,
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

  LineChartData placeholderData = LineChartData.prepareData(
    points: [
      LineChartPoint(0, 100),
      LineChartPoint(1, 100),
      LineChartPoint(2, 100),
      LineChartPoint(3, 100),
      LineChartPoint(4, 100),
      LineChartPoint(5, 100),
      LineChartPoint(6, 100),
      LineChartPoint(7, 100),
      LineChartPoint(8, 100),
      LineChartPoint(9, 100),
      LineChartPoint(10, 97),
      LineChartPoint(11, 96),
      LineChartPoint(12, 90),
      LineChartPoint(13, 82),
      LineChartPoint(14, 80),
      LineChartPoint(15, 99),
      LineChartPoint(16, 100),
      LineChartPoint(17, 100),
      LineChartPoint(18, 100),
      LineChartPoint(19, 100),
      LineChartPoint(20, 100),
      LineChartPoint(21, 100),
      LineChartPoint(22, 100),
      LineChartPoint(23, 100),
    ],
    preferredMinY: 0,
    preferredMaxY: 100
  );
}
