import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_mobile/release_card.dart';
import 'package:sentry_mobile/types/release.dart';

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
