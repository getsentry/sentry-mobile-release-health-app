
import 'package:flutter/material.dart';

class OnboardingDetailScreen extends StatelessWidget {
  OnboardingDetailScreen(this._headline, this._subtitle);

  final String _headline;
  final String _subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 22, top: 64, right: 22, bottom: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            height: 256,
            width: 256,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(128))),
          ),
          SizedBox(height: 32),
          Text(
              _headline,
              style: Theme.of(context).textTheme.headline1
          ),
          SizedBox(height: 10),
          Text(
              _subtitle,
              style: Theme.of(context).textTheme.subtitle1
          ),
        ],
      )
    );
  }
}