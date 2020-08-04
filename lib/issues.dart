import 'package:flutter/material.dart';
import './types/group.dart';
import 'dart:convert';

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
      child: Column(
        children: sampleGroups.map((group) => Issue(
          title: group.title
        )).toList(),
      ),
    );
  }
}

class Issue extends StatelessWidget {
  Issue({@required this.title});
  final String title;
  
  Widget build(BuildContext context) => Column(children: <Widget>[Text(title)]);
}

