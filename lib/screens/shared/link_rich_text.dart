// @dart=2.9


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/sentry_colors.dart';

class LinkRichText extends StatelessWidget {
  LinkRichText(this._prefix, this._link, this._linkText, this._suffix, this._textStyle);

  final String _prefix;
  final String _link;
  final String _linkText;
  final String _suffix;
  final TextStyle _textStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: _prefix,
            style: _textStyle,
          ),
          TextSpan(
            text: _linkText,
            style: TextStyle(
              fontFamily: _textStyle.fontFamily,
              fontSize: _textStyle.fontSize,
              color: SentryColors.royalBlue
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () { launch(_link); },
          ),
          TextSpan(
            text: _suffix,
            style: _textStyle,
          ),
        ],
      ),
    );
  }
}
