import 'package:flutter/material.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

class EmptyScreen extends StatelessWidget {
  EmptyScreen({@required this.title, @required this.text, @required this.button, @required this.action});

  final String title;
  final String text;
  final String button;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(32.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center,),
            SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
            SizedBox(height: 22),
            RaisedButton(
              child: Text(button),
              textColor: Colors.white,
              color: SentryColors.rum,
              onPressed: () async {
                action();
              },
            )
          ]
      ),
    );
  }
}