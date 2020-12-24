import 'package:flutter/material.dart';

import '../../screens/chart/line_chart.dart';
import '../../screens/chart/line_chart_data.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../utils/sentry_icons.dart';

class ReleaseHealthChartRow extends StatelessWidget {
  ReleaseHealthChartRow({@required this.title, @required this.data, this.parentData});

  final String title;
  final List<LineChartPoint> data;
  final int hours = 12;

  final List<LineChartPoint> parentData;

  @override
  Widget build(BuildContext context) {
    final List<LineChartPoint> dataLeading = data.take(hours).toList();
    final List<LineChartPoint> dataTrailing = data.reversed.take(hours).toList().reversed.toList();
    List<LineChartPoint> parentData;
    if (this.parentData != null) {
      parentData = this.parentData.reversed.take(hours).toList().reversed.toList();
    }

    int numberOfIssues;
    if (dataTrailing.isNotEmpty) {
      numberOfIssues = dataTrailing
          .map((e) => e.y.toInt())
          .reduce((a, b) => a + b);
    } else {
      numberOfIssues = 0;
    }

    final leadingLineChartData = LineChartData.prepareData(points: dataLeading);
    LineChartData lineChartData;
    if (parentData != null) {
      final parentLineChartData = LineChartData.prepareData(points: parentData);
      lineChartData = LineChartData.prepareData(
        points: dataTrailing,
        preferredMinY: parentLineChartData.minY,
        preferredMaxY: parentLineChartData.maxY,
      );
    } else {
      lineChartData = LineChartData.prepareData(points: dataTrailing);
    }

    final change = getPercentChange(leadingLineChartData.countY, lineChartData.countY);

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
                        color: Color(0xFF18181A),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ))),
              Text('Last $hours hours',
                  style: TextStyle(
                    color: Color(0xFFB9C1D9),
                    fontSize: 12,
                  ))
            ],
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: LineChart(
                    data: lineChartData,
                    lineWidth: 2.0,
                    lineColor: Color(0xff81B4FE),
                    gradientStart: Color(0x2881b4fe),
                    gradientEnd: Colors.transparent
                ),
                height: 35,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text('$numberOfIssues',
                      style: TextStyle(
                        color: Color(0xFF18181A),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(getTrendPercentage(change),
                    style: TextStyle(
                      color: Color(0xFFB9C1D9),
                      fontSize: 12,
                    )),
                  Padding(
                    padding: EdgeInsets.only(left: change == 0 ? 0 : 7),
                    child: getTrendIcon(change),
                  )
                ]
              )
            ],
          ),
        ]));
  }

  // Helper

  double getPercentChange(double previous, double current) {
    if (previous == 0.0) {
      return 0.0; // Cannot show % increase from previous zero value.
    }
    final increase = current - previous;
    return increase / previous * 100.0;
  }

  String getTrendSign(double change) {
    return change > 0
        ? '+'
        : '';
  }

  String getTrendPercentage(double change) {
    return change == 0 ? '--' : getTrendSign(change) + change.floor().toString() + '%';
  }

  Icon getTrendIcon(double change) {
    if (change == 0) {
      return null;
    }
    return change > 0
        ? Icon(SentryIcons.trend_up, color: Color(0xffEE6855), size: 8.0)
        : Icon(SentryIcons.trend_down, color: Color(0xff23B480), size: 8.0);
  }
}