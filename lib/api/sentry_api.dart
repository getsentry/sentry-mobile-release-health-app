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
        headers: {'Cookie': session.toString()});
  }

  Future<Response> projects(Organization organization) async {
    return client.get('$baseUrl/organizations/${organization.slug}/projects/',
        headers: {'Cookie': session.toString()});
  }

  void close() {
    client.close();
  }
}