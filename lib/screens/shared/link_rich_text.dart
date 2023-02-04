import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/sentry_colors.dart';

class LinkRichText extends StatelessWidget {
  LinkRichText(this._link, this._linkText,
      {this.prefix, this.suffix, this.textStyle, this.linkStyle});

  final Uri _link;
  final String _linkText;

  final String? prefix;
  final String? suffix;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textStyle,
        children: [
          if (prefix != null)
            TextSpan(
              text: prefix,
              style: textStyle,
            ),
          TextSpan(
            text: _linkText,
            style: TextStyle(
              fontFamily: linkStyle?.fontFamily ?? textStyle?.fontFamily,
              fontSize: linkStyle?.fontSize ?? textStyle?.fontSize,
              color: linkStyle?.color ?? SentryColors.royalBlue,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(_link);
              },
          ),
          if (suffix != null)
            TextSpan(
              text: suffix,
              style: textStyle,
            ),
        ],
      ),
    );
  }
}
