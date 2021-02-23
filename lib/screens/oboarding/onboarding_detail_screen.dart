import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

class OnboardingDetailScreen extends StatefulWidget {
  OnboardingDetailScreen(this._firstImage, this._secondImage, this._subtitle);

  final String _firstImage;
  final String _secondImage;
  final String _subtitle;

  @override
  _OnboardingDetailScreenState createState() => _OnboardingDetailScreenState(_firstImage, _secondImage, _subtitle);
}

class _OnboardingDetailScreenState extends State<OnboardingDetailScreen> {
  _OnboardingDetailScreenState(this._firstImage, this._secondImage, this._subtitle);

  final String _firstImage;
  final String _secondImage;
  final String _subtitle;

  var _secondImageVisible = false;

  @override
  void initState() {
    super.initState();
    _fadeOutSecondImageDelayed();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(_firstImage)
                  ),
                  if (_secondImage != null) AnimatedOpacity(
                    opacity: _secondImageVisible ? 1.0 : 0.0,
                    duration: Duration(seconds: 3),
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(_secondImage)
                    ),
                  )
                ],
              )
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
  
  void _fadeOutSecondImageDelayed() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _secondImageVisible = true;
      });
    });
  }
}