import 'package:flutter/material.dart';

import '../../utils/sentry_colors.dart';
import 'health_card_view_model.dart';

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
              side: BorderSide(color: Color(0x33B9C1D9), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          elevation: 4,
          shadowColor: SentryColors.silverChalice.withAlpha((256 * 0.2).toInt()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16),
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
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(bottom: 16),
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
                          child: viewModel.trendIcon,
                        )
                      ]
                  )
              ),
            ],
          ),
        ));
  }
}