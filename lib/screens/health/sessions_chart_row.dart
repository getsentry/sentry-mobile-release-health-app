import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../redux/state/session_state.dart';
import '../../screens/health/sessions_chart_row_view_model.dart';
import '../../utils/sentry_colors.dart';
import '../../utils/sentry_icons.dart';
import '../../utils/session_formatting.dart';
import '../chart/line/line_chart.dart';
import '../chart/line/line_chart_options.dart';


class SessionsChartRow extends StatelessWidget {
  SessionsChartRow(
      {required this.title,
      required this.color,
      required this.sessionState,
      this.flipDeltaColors = false});

  final String title;
  final Color color;
  final SessionState? sessionState;
  final bool flipDeltaColors;

  @override
  Widget build(BuildContext context) {
    final viewModel = SessionsChartRowViewModel.create(sessionState);

    return Container(
        padding: EdgeInsets.only(bottom: 22),
        margin: EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0x33B9C1D9))),
        ),
        child: Container(
          height: 38,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: 72,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(title,
                      style: TextStyle(
                        color: SentryColors.revolver,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ))),
            ),
            Expanded(
                child: viewModel.data == null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              LinearProgressIndicator(
                                  minHeight: 2.0,
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(color))
                            ]),
                        height: 35,
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: LineChart(
                          viewModel.data!,
                          options: LineChartOptions(
                            lineWidth: 5.0,
                            lineColor: color,
                            gradientStart: color.withAlpha(84),
                            gradientEnd: color.withAlpha(28),
                          ),
                        ),
                        height: 35,
                      )),
            Container(
              width: 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                            viewModel.numberOfIssues.formattedNumberOfSession(),
                            style: TextStyle(
                              color: SentryColors.woodSmoke,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ))),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: viewModel.percentChange == 0.0 ? 0 : 7),
                            child: _getTrendIcon(
                                viewModel.percentChange, flipDeltaColors),
                          ),
                          Text(_getTrendPercentage(viewModel.percentChange),
                              style: TextStyle(
                                color: SentryColors.lavenderGray,
                                fontSize: 12,
                              ))
                        ]),
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  // Helper

  String _getTrendPercentage(double? change) {
    return change == null || change == 0
        ? '--'
        : change.floor().abs().toString() + '%';
  }

  Color _getTrendColor(double change, bool flipDelta) {
    return change > 0
        ? !flipDelta
            ? Color(0xffEE6855)
            : Color(0xff23B480)
        : !flipDelta
            ? Color(0xff23B480)
            : Color(0xffEE6855);
  }

  Icon? _getTrendIcon(double? change, bool flipDeltaColor) {
    if (change == null || change == 0) {
      return null;
    }
    final trendColor = _getTrendColor(change, flipDeltaColor);
    return change > 0
        ? Icon(SentryIcons.trend_up, color: trendColor, size: 8.0)
        : Icon(SentryIcons.trend_down, color: trendColor, size: 8.0);
  }
}
