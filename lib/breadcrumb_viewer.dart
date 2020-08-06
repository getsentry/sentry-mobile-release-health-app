import 'dart:async';
import 'package:flutter/material.dart';

import 'text_theme_ext.dart';
import 'types/breadcrumb.dart';

class BreadcrumbViewer extends StatelessWidget {
  BreadcrumbViewer({@required this.breadcrumbs});

  final List<Breadcrumb> breadcrumbs;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      padding: EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
      )),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child:
                Text('BREADCRUMBS', style: Theme.of(context).textTheme.caption),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(16),
            height: 340,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                  color: Color(0xffc6becf),
                  width: 1,
                )),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    final breadcrumb =
                        breadcrumbs[breadcrumbs.length - 1 - index];

                    return BreadcrumbCard(
                      breadcrumb: breadcrumb,
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}

class BreadcrumbCard extends StatelessWidget {
  BreadcrumbCard({@required this.breadcrumb});

  final Breadcrumb breadcrumb;

  Widget build(BuildContext context) {
    IconData icon = Icons.info_outline;
    Color iconColor = Colors.black54;
    if (breadcrumb.level == 'error') {
      icon = Icons.error_outline;
      iconColor = Colors.red;
    } else if (breadcrumb.level == 'warning') {
      icon = Icons.error_outline;
      iconColor = Colors.orange;
    } else if (breadcrumb.category == 'xhr' || breadcrumb.category == 'fetch') {
      icon = Icons.wifi;
      iconColor = Colors.green;
    }

    List<Widget> dataRows = [];
    breadcrumb.data.forEach((key, dynamic value) {
      dataRows.add(BreadcrumbDataRow(title: key, value: '$value'));
    });

    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color:
                breadcrumb.level == 'error' ? Colors.red[50] : Colors.grey[100],
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: 1))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                )),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.18,
                            margin: EdgeInsets.only(top: 1, right: 4),
                            child: Text(breadcrumb.category,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: 0.3))),
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Text(breadcrumb.message ?? '',
                                  style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .code
                                          .fontFamily,
                                      fontSize: 11,
                                      color:
                                          Theme.of(context).primaryColorDark))),
                        ),
                      ],
                    ),
                    ...dataRows
                  ],
                )),
            Container(
              child: Text(
                  '${breadcrumb.timestamp.hour.toString()}:${breadcrumb.timestamp.minute.toString()}:${breadcrumb.timestamp.second.toString()}',
                  style: TextStyle(fontSize: 10, letterSpacing: 0.2)),
            ),
          ],
        ));
  }
}

class BreadcrumbDataRow extends StatelessWidget {
  BreadcrumbDataRow({@required this.title, this.value});
  final String title;
  final String value;

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.18,
              margin: EdgeInsets.only(top: 1, right: 4),
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 12,
                      letterSpacing: 0.3))),
          Expanded(
            flex: 1,
            child: Container(
                child: Text(value ?? '',
                    style: TextStyle(
                        fontFamily: Theme.of(context).textTheme.code.fontFamily,
                        fontSize: 11,
                        color: Theme.of(context).primaryColorDark))),
          )
        ],
      ),
    );
  }
}
