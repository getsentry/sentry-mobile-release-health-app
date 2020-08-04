import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_mobile/release_card.dart';

Future<List<Release>> fetchReleases() async {
  final response = await http.get('https://mminar.com/releases.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final responseJson = json.decode(response.body) as List;
    return responseJson.map((dynamic r) => Release.fromJson(r)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Release');
  }
}

class Release {
  Release(
      {this.version,
      this.project,
      this.date,
      this.issues,
      this.crashes,
      this.crashFreeUsers,
      this.crashFreeSessions,
      this.users24h,
      this.usersTotal,
      this.sessions24h,
      this.sessionsTotal,
      this.durationP90});

  factory Release.fromJson(dynamic json) {
    return Release(
        version: json['versionInfo']['description'] as String,
        project: json['projects'][0]['slug'] as String,
        date: json['dateCreated']
            as String, // lastDeploy.dateFinished ?? dateCreated
        issues: json['newGroups'] as int,
        crashes: json['projects'][0]['healthData']['sessionsCrashed'] as int,
        crashFreeUsers:
            json['projects'][0]['healthData']['crashFreeUsers'] as double,
        crashFreeSessions:
            json['projects'][0]['healthData']['crashFreeSessions'] as double,
        users24h: json['projects'][0]['healthData']['totalUsers24h'] as int,
        usersTotal: json['projects'][0]['healthData']['totalUsers'] as int,
        sessions24h:
            json['projects'][0]['healthData']['totalSessions24h'] as int,
        sessionsTotal:
            json['projects'][0]['healthData']['totalSessions'] as int,
        durationP90:
            json['projects'][0]['healthData']['durationP90'] as double);
  }

  final String version;
  final String project;
  final String date;
  final int issues;
  final int crashes;
  final double crashFreeUsers;
  final double crashFreeSessions;
  final int users24h;
  final int usersTotal;
  final int sessions24h;
  final int sessionsTotal;
  final double durationP90;
}

class ReleaseHealth extends StatefulWidget {
  const ReleaseHealth({Key key}) : super(key: key);

  @override
  _ReleaseHealthState createState() => _ReleaseHealthState();
}

class _ReleaseHealthState extends State<ReleaseHealth> {
  Future<List<Release>> futureReleases;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      futureReleases = fetchReleases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Release>>(
        future: futureReleases,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ReleaseCard(release: snapshot.data[index]);
                },
              ),
              onRefresh: fetchData,
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
