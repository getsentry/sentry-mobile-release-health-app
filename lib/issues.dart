import 'package:flutter/material.dart';
import './types/group.dart';
import 'dart:convert';

const String jsonString = '''
  {
    "groups": [{
        "platform": "cocoa",
        "lastSeen": "2020-08-02T16:39:34.994565Z",
        "numComments": 0,
        "userCount": 5,
        "stats": {
            "24h": [
                [
                    1596373200,
                    0
                ],
                [
                    1596376800,
                    0
                ],
                [
                    1596380400,
                    0
                ],
                [
                    1596384000,
                    1
                ],
                [
                    1596387600,
                    0
                ],
                [
                    1596391200,
                    0
                ],
                [
                    1596394800,
                    0
                ],
                [
                    1596398400,
                    0
                ],
                [
                    1596402000,
                    0
                ],
                [
                    1596405600,
                    0
                ],
                [
                    1596409200,
                    0
                ],
                [
                    1596412800,
                    0
                ],
                [
                    1596416400,
                    0
                ],
                [
                    1596420000,
                    0
                ],
                [
                    1596423600,
                    0
                ],
                [
                    1596427200,
                    0
                ],
                [
                    1596430800,
                    0
                ],
                [
                    1596434400,
                    0
                ],
                [
                    1596438000,
                    0
                ],
                [
                    1596441600,
                    0
                ],
                [
                    1596445200,
                    0
                ],
                [
                    1596448800,
                    0
                ],
                [
                    1596452400,
                    0
                ],
                [
                    1596456000,
                    0
                ]
            ]
        },
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
    }]
  }
''';

Map<String, dynamic> groups = jsonDecode(jsonString) as Map<String, dynamic>;

final List<dynamic> groupLists = groups['groups'] as List<dynamic>;
final List<Group> sampleGroups = groupLists.map((dynamic groupJson) => Group.fromJson(groupJson as Map<String, dynamic>)).toList();

class Issues extends StatefulWidget {
  const Issues({Key key}) : super(key: key);

  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
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
  
  Widget build(BuildContext context) => Column(children: <Widget>[Text(title)],);
}

