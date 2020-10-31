import 'dart:io';
import 'package:http/http.dart';

import 'package:sentry_mobile/types/organization.dart';

class SentryApi {
  SentryApi(this.session);

  final Cookie session;
  final client = Client();
  final baseUrl = 'https://sentry.io/api/0';

  Future<Response> organizations() async {
    return client.get('$baseUrl/organizations/?member=1',
        headers: {'Cookie': session.toString()}
    );
  }

  Future<Response> projects(String slug) async {
    return client.get('$baseUrl/organizations/$slug/projects/',
        headers: {'Cookie': session.toString()}
    );
  }

  Future<Response> releases(String projectId, {int perPage = 25, int health = 1, int flatten = 0, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'perPage': '$perPage',
      'health': '$health',
      'flatten': '$flatten',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    return client.get(Uri.https(baseUrl, '/releases/$projectId', queryParameters),
        headers: {'Cookie': session.toString()}
    );
  }

  void close() {
    client.close();
  }
}