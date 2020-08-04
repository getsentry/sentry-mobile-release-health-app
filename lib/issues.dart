import 'package:flutter/material.dart';
import './types/group.dart';
import 'dart:convert';
import 'package:timeago/timeago.dart' as timeago;

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
        "count": 5,
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
        "count": 23,
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



class Issues extends StatefulWidget {
  const Issues({Key key}) : super(key: key);

  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  List<Group> sampleGroups = [];

  @override
  void initState() {
    super.initState();
    getSampleData();
  }

  void getSampleData() {
    setState(() {
      Map<String, dynamic> groups = jsonDecode(jsonString) as Map<String, dynamic>;

      final List<dynamic> groupLists = groups['groups'] as List<dynamic>;
      sampleGroups = groupLists.map((dynamic groupJson) => Group.fromJson(groupJson as Map<String, dynamic>)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: sampleGroups.length,
        itemBuilder: (context, index) {
          final group = sampleGroups[index];

          return Issue(title: group.metadata.type, value: group.title, culprit: group.culprit, userCount: group.userCount, count: group.count, lastSeen: group.lastSeen, firstSeen: group.lastSeen);
        },
      ),
    );
  }
}

class Issue extends StatelessWidget {
  Issue({@required this.title, this.value, @required this.culprit, @required this.userCount, @required this.count, @required this.firstSeen, @required this.lastSeen});
  final String title;
  final String value;
  final String culprit;
  final int userCount;
  final int count;
  final DateTime firstSeen;
  final DateTime lastSeen;
  
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: EdgeInsets.all(14.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(culprit, style: TextStyle(color: Colors.black54)),
                  Text(value, style: TextStyle(color: Colors.black87)),
                  Text(
                    '${timeago.format(lastSeen)} — ${timeago.format(firstSeen)}',
                  style: TextStyle(color: Colors.black54))
                ],
            )
          ),
          Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold))
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(userCount.toString(), style: TextStyle(fontWeight: FontWeight.bold))
            ),
          ],)
        ]
      )
    ),
  );
}

