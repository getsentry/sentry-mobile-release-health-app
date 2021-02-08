import 'package:flutter/material.dart';

import '../../redux/state/session_state.dart';
import '../../screens/chart/line_chart.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../screens/health/sessions_chart_row_view_model.dart';
import '../../utils/sentry_colors.dart';
import '../../utils/sentry_icons.dart';

class SessionsChartRow extends StatelessWidget {
  SessionsChartRow({@required this.title, @required this.color, @required this.sessionState, this.parentPoints});

  final String title;
  final Color color;
  final SessionState sessionState;
  final List<LineChartPoint> parentPoints;

  @override
  Widget build(BuildContext context) {
    final viewModel = SessionsChartRowViewModel.create(sessionState, parentPoints ?? []);
    
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
              Text('Last 24 hours',
                  style: TextStyle(
                    color: SentryColors.mamba,
                    fontSize: 12,
                  ))
            ],
          ),
          Expanded(
              child:
                viewModel.data == null
                ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LinearProgressIndicator(
                            minHeight: 2.0,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(color)
                        )
                      ]
                  ),
                  height: 35,
                )
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: LineChart(
                      data: viewModel.data,
                      lineWidth: 2.0,
                      lineColor: color,
                      gradientStart: color.withAlpha(84),
                      gradientEnd: color.withAlpha(28),
                      cubicLines: false
                  ),
                  height: 35,
                )
          ),
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