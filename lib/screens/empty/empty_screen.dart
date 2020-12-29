import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  EmptyScreen(this.title, this.text, this.action);

  final String title;
  final String text;
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
              child: Text('Bookmark project'),
              textColor: Colors.white,
              color: Color(0xff4e3fb4),
              onPressed: () async {
                action();
              },
            )
          ]
      ),
    );
  }
}