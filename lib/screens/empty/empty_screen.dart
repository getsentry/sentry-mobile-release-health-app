import 'package:flutter/material.dart';

import '../../utils/sentry_colors.dart';

class EmptyScreen extends StatelessWidget {
  EmptyScreen({@required this.title, @required this.text, @required this.button, @required this.action});

  final String title;
  final String text;
  final String button;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(32.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center,),
              SizedBox(height: 8),
              Text(text, textAlign: TextAlign.center),
              SizedBox(height: 22),
              ElevatedButton(
                child: Text(button),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(SentryColors.rum),
                ),
                onPressed: () async {
                  action();
                },
              )
            ]
        ),
      ),
    );
  }
}