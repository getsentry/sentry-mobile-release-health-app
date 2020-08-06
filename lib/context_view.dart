import 'package:flutter/material.dart';

import 'text_theme_ext.dart';

const double HIDDEN_HEIGHT = 240;

class ContextView extends StatefulWidget {
  const ContextView({Key key, this.title, this.value}) : super(key: key);

  final String title;
  final dynamic value;

  @override
  _ContextState createState() => _ContextState(title: title, value: value);
}

class _ContextState extends State<ContextView> {
  _ContextState({@required this.title, @required this.value});

  final String title;
  final dynamic value;
  GlobalKey _key = GlobalKey();

  bool isHidden = true;
  double height;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_getSize);
    super.initState();
  }

  void _getSize(dynamic _) {
    if (height == null) {
      setState(() {
        final RenderBox renderBox =
            _key.currentContext.findRenderObject() as RenderBox;
        final size = renderBox.size;

        height = size.height;
      });
    }
  }

  void toggleHidden() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  Widget build(BuildContext context) {
    final List<Widget> valueWidgets = [];
    final List<Widget> headerWidgets = [
      Text(title, style: Theme.of(context).textTheme.caption)
    ];

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

    bool useHidden = false;
    if (height != null && height > HIDDEN_HEIGHT) {
      useHidden = true;
    }

    if (useHidden) {
      headerWidgets.add(IconButton(
        onPressed: toggleHidden,
        icon: isHidden ? Icon(Icons.expand_more) : Icon(Icons.expand_less),
      ));
    }

    return ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
              begin: Alignment(0, 0.4),
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                useHidden && isHidden ? Colors.transparent : Colors.black
              ]).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: AnimatedContainer(
          key: _key,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
                width: 1.0, color: Theme.of(context).primaryColorLight),
          )),
          height: useHidden && isHidden ? HIDDEN_HEIGHT : height,
          duration: Duration(milliseconds: 500),
          child: Column(children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: headerWidgets,
                )),
            ...valueWidgets,
          ]),
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
