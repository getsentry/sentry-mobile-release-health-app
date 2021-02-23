import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

class OnboardingDetailScreen extends StatelessWidget {
  OnboardingDetailScreen(this._image, this._subtitle);

  final AssetImage _image;
  final String _subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Image(image: _image)
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
                _subtitle,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline3.fontFamily,
                  fontSize: Theme.of(context).textTheme.headline3.fontSize,
                  color: SentryColors.revolver
                ),
                textAlign: TextAlign.center,
            ),
          ),
        ),
      ]
    );
  }
}