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
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  viewModel.value,
                  style: TextStyle(
                    color: viewModel.color,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
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
                          viewModel.change,
                          style: TextStyle(
                            color: SentryColors.mamba,
                            fontSize: 13,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: viewModel.trendIcon ?? Spacer(),
                        )
                      ]
                  )
              ),
            ],
          ),
        ));
  }
}