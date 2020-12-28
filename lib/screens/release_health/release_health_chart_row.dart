import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

import '../../screens/chart/line_chart.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../screens/release_health/release_health_chart_row_view_model.dart';
import '../../utils/sentry_icons.dart';

class ReleaseHealthChartRow extends StatelessWidget {
  ReleaseHealthChartRow({@required this.title, @required this.points, this.parentPoints});

  final String title;
  final List<LineChartPoint> points;
  final List<LineChartPoint> parentPoints;

  @override
  Widget build(BuildContext context) {
    final viewModel = ReleaseHealthChartRowViewModel.createByHalvingPoints(points, parentPoints ?? []);
    
    return Container(
        padding: EdgeInsets.only(bottom: 22),
        margin: EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 1, color: Color(0x33B9C1D9))),
        ),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(title,
                      style: TextStyle(
                        color: SentryColors.revolver,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ))),
              Text('Last ${viewModel.data.points.length} hours',
                  style: TextStyle(
                    color: SentryColors.rum,
                    fontSize: 12,
                  ))
            ],
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: LineChart(
                    data: viewModel.data,
                    lineWidth: 2.0,
                    lineColor: SentryColors.tapestry,
                    gradientStart: SentryColors.tapestry.withAlpha(28),
                    gradientEnd: Colors.transparent
                ),
                height: 35,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text('${viewModel.numberOfIssues}',
                      style: TextStyle(
                        color: SentryColors.woodSmoke,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_getTrendPercentage(viewModel.percentChange),
                    style: TextStyle(
                      color: SentryColors.lavenderGray,
                      fontSize: 12,
                    )),
                  Padding(
                    padding: EdgeInsets.only(left: viewModel.percentChange == 0.0 ? 0 : 7),
                    child: _getTrendIcon(viewModel.percentChange),
                  )
                ]
              )
            ],
          ),
        ]));
  }

  // Helper

  String _getTrendSign(double change) {
    return change > 0 ? '+' : '';
  }

  String _getTrendPercentage(double change) {
    return change == 0 ? '--' : _getTrendSign(change) + change.floor().toString() + '%';
  }

  Icon _getTrendIcon(double change) {
    if (change == 0) {
      return null;
    }
    return change > 0
        ? Icon(SentryIcons.trend_up, color: Color(0xffEE6855), size: 8.0)
        : Icon(SentryIcons.trend_down, color: Color(0xff23B480), size: 8.0);
  }
}