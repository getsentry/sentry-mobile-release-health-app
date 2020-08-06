import 'package:flutter/material.dart';

import 'text_theme_ext.dart';

const double HIDDEN_HEIGHT = 240;

class ContextView extends StatelessWidget {
  const ContextView({@required this.title, @required this.value});

  final String title;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final List<Widget> valueWidgets = [];

    if (value is Map) {
      if (title == 'redux.state') {
        valueWidgets
            .add(ContextRow(name: 'Latest State', value: value.toString()));
      } else {
        value.forEach((String key, String value) =>
            valueWidgets.add(ContextRow(name: key, value: value)));
      }
    } else if (value is String) {
      valueWidgets.add(ContextRow(name: title, value: value as String));
    }

    return Container(
        child: ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.caption),
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 12),
          child: Column(
            children: valueWidgets,
          ),
        )
      ],
    ));
  }
}

class ContextRow extends StatelessWidget {
  ContextRow({@required this.name, @required this.value});
  final String name;
  final String value;

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 6),
        alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(right: 4, top: 6),
                    alignment: Alignment.topLeft,
                    child: Text(name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600))),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.68,
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Text(value,
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.code.fontFamily,
                          color: Theme.of(context).primaryColorDark)))
            ]));
  }
}
