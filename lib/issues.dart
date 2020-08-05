import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import './types/group.dart';
import 'issue_screen.dart';

const String jsonString = '''
  {
    "groups": [
      {
        "platform": "cocoa",
        "lastSeen": "2020-08-02T16:39:34.994565Z",
        "numComments": 0,
        "userCount": 5,
        "stats": {},
        "culprit": "?(app:///main.jsbundle)",
        "title": "Error: Failed to grant permission",
        "id": "1773677544",
        "assignedTo": null,
        "logger": "javascript",
        "type": "error",
        "annotations": [],
        "metadata": {
            "function": "value",
            "type": "Error",
            "value": "Failed to grant permission",
            "filename": "app:///main.jsbundle"
        },
        "status": "unresolved",
        "subscriptionDetails": null,
        "isPublic": false,
        "hasSeen": false,
        "shortId": "TOUR-MOBILE-3ED",
        "shareId": null,
        "firstSeen": "2020-07-08T20:10:22.111494Z",
        "count": "5",
        "permalink": "https://sentry.io/organizations/monos-digital/issues/1773677544/",
        "level": "error",
        "isSubscribed": false,
        "isBookmarked": false,
        "project": {
            "platform": "react-native",
            "slug": "tour-mobile",
            "id": "1459798",
            "name": "React-Native"
        },
        "statusDetails": {}
      },
      {
        "platform": "javascript",
        "lastSeen": "2020-08-02T12:23:25.090695Z",
        "numComments": 0,
        "userCount": 6,
        "stats": {},
        "culprit": "performSyncWorkOnRoot([native code])",
        "title": "Error: Text strings must be rendered within a <Text> component.",
        "id": "1793417200",
        "assignedTo": null,
        "logger": null,
        "type": "error",
        "annotations": [],
        "metadata": {
            "function": "performSyncWorkOnRoot",
            "type": "Error",
            "value": "Text strings must be rendered within a <Text> component.",
            "filename": "[native code]"
        },
        "status": "unresolved",
        "subscriptionDetails": null,
        "isPublic": false,
        "hasSeen": true,
        "shortId": "TOUR-MOBILE-3VH",
        "shareId": null,
        "firstSeen": "2020-07-19T08:18:00.302863Z",
        "count": "23",
        "permalink": "https://sentry.io/organizations/monos-digital/issues/1793417200/",
        "level": "error",
        "isSubscribed": false,
        "isBookmarked": false,
        "project": {
            "platform": "react-native",
            "slug": "tour-mobile",
            "id": "1459798",
            "name": "React-Native"
        },
        "statusDetails": {}
      }
    ]
  }
''';

class IssuesScreenBuilder extends StatelessWidget {
  const IssuesScreenBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'Issues',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'Issues':
            return MaterialPageRoute<dynamic>(
                builder: (context) => IssuesScreen(), settings: settings);
            break;

          case 'Event':
            return MaterialPageRoute<dynamic>(
                builder: (context) => IssueScreen(), settings: settings);
            break;

          default:
            throw Exception("Invalid route");
        }
      },
    );
  }
}

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({Key key}) : super(key: key);

  @override
  _IssuesScreenState createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  List<Group> sampleGroups = [];

  @override
  void initState() {
    super.initState();
    getSampleData();
  }

  void getSampleData() {
    setState(() {
      Map<String, dynamic> groups =
          jsonDecode(jsonString) as Map<String, dynamic>;

      final List<dynamic> groupLists = groups['groups'] as List<dynamic>;
      sampleGroups = groupLists
          .map((dynamic groupJson) =>
              Group.fromJson(groupJson as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 34,
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: 48,
                    alignment: Alignment.centerRight,
                    child: Text('EVENTS',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500))),
                Container(
                    margin: EdgeInsets.only(right: 16.0),
                    width: 48,
                    alignment: Alignment.centerRight,
                    child: Text('USERS',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500)))
              ],
            )),
        Expanded(
          child: ListView.builder(
            itemCount: sampleGroups.length,
            itemBuilder: (context, index) {
              final group = sampleGroups[index];

              return Issue(
                  title: group.metadata.type,
                  value: group.title,
                  culprit: group.culprit,
                  userCount: group.userCount,
                  count: group.count,
                  lastSeen: group.lastSeen,
                  firstSeen: group.lastSeen);
            },
          ),
        )
      ],
    );
  }
}

class Issue extends StatelessWidget {
  Issue(
      {@required this.title,
      this.value,
      @required this.culprit,
      @required this.userCount,
      @required this.count,
      @required this.firstSeen,
      @required this.lastSeen});

  final String title;
  final String value;
  final String culprit;
  final int userCount;
  final String count;
  final DateTime firstSeen;
  final DateTime lastSeen;

  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => IssueScreen()));
      },
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(culprit, style: TextStyle(color: Colors.black54)),
                      Text(value, style: TextStyle(color: Colors.black87)),
                      Text(
                          '${timeago.format(lastSeen)} — ${timeago.format(firstSeen)}',
                          style: TextStyle(color: Colors.black54))
                    ],
                  )),
              Row(
                children: <Widget>[
                  Container(
                      width: 48,
                      alignment: Alignment.centerRight,
                      child: Text(count,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      width: 48,
                      alignment: Alignment.centerRight,
                      child: Text(userCount.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              )
            ])),
      ));
}
