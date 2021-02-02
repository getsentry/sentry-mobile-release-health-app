import 'package:flutter/material.dart';

import '../../utils/sentry_colors.dart';

class HealthDivider extends StatelessWidget {
  HealthDivider(
      {@required this.title,
        @required this.onSeeAll});

  final String title;
  final void Function() onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6.0, bottom: 22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: SentryColors.mamba,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          // MaterialButton(
          //   minWidth: 0,
          //   padding: EdgeInsets.zero,
          //   onPressed: onSeeAll,
          //   child: Text(
          //     'See All',
          //     style: TextStyle(
          //       color: Color(0xFF81B4FE),
          //       fontWeight: FontWeight.w500,
          //       fontSize: 16,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}