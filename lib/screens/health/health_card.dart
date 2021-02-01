import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sentry_mobile/screens/health/health_card_view_model.dart';

import '../../utils/sentry_colors.dart';
import '../../utils/sentry_icons.dart';

class HealthCard extends StatelessWidget {
  HealthCard(
      {@required this.title, this.viewModel});

  final String title;
  final HealthCardViewModel viewModel;

  final warningThreshold = 99.5;
  final dangerThreshold = 98;
  final valueFormat = NumberFormat('###.##');

  Color getColor() {
    return viewModel.value == null
        ? SentryColors.lavenderGray
        : viewModel.value > warningThreshold
        ? SentryColors.shamrock
        : viewModel.value > dangerThreshold ? SentryColors.lightningYellow : SentryColors.burntSienna;
  }

  Icon getIcon(Color color) {
    if (viewModel.value == null) {
      return null;
    }
    return viewModel.value > warningThreshold
        ? Icon(SentryIcons.status_ok, color: color, size: 20.0)
        : viewModel.value > dangerThreshold
        ? Icon(SentryIcons.status_warning, color: color, size: 20.0)
        : Icon(SentryIcons.status_error, color: color, size: 20.0);
  }

  String getTrendSign() {
    return viewModel.change > 0 ? '+' : '';
  }

  Icon getTrendIcon() {
    if (viewModel.change == null || viewModel.change == 0) {
      return null;
    }
    return viewModel.change == 0
        ? Icon(SentryIcons.trend_same, color: SentryColors.lavenderGray, size: 8.0)
        : viewModel.change > 0
        ? Icon(SentryIcons.trend_up, color: SentryColors.shamrock, size: 8.0)
        : Icon(SentryIcons.trend_down, color: SentryColors.burntSienna, size: 8.0);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          elevation: 4,
          shadowColor: SentryColors.silverChalice.withAlpha((256 * 0.2).toInt()),
          margin: EdgeInsets.only(left: 7, right: 7, top: 0, bottom: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: getColor().withAlpha(0x19),
                    child: getIcon(getColor()),
                  )
              ),
              Text(
                viewModel.value != null ? valueFormat.format(viewModel.value) + '%' : '--',
                style: TextStyle(
                  color: getColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: SentryColors.revolver,
                      fontSize: 14,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child:
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.change != null ? getTrendSign() +valueFormat.format(viewModel.change) + '%' : '--',
                          style: TextStyle(
                            color: SentryColors.mamba,
                            fontSize: 13,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: getTrendIcon() ?? Spacer(),
                        )
                      ]
                  )
              ),
            ],
          ),
        ));
  }
}