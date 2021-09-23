import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  EmptyScreen(
      {required this.title,
      required this.text,
      required this.button,
      required this.action,
      this.secondaryButton,
      this.secondaryAction});

  final String title;
  final String text;

  final String button;
  final void Function() action;

  final String? secondaryButton;
  final void Function()? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Text(title,
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center),
      SizedBox(height: 8),
      Text(text, textAlign: TextAlign.center),
      SizedBox(height: 22),
      ElevatedButton(
        child: Text(button),
        onPressed: action,
      )
    ];
    final secondaryButton = this.secondaryButton;
    if (secondaryButton != null) {
      children.add(TextButton(
        child: Text(secondaryButton),
        onPressed: secondaryAction,
      ));
    }
    return Center(
      child: Container(
        margin: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
