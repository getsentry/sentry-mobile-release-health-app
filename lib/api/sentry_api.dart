import 'dart:io';
import 'package:http/http.dart';

class SentryApi {
  SentryApi(this.session);

  final Cookie session;
  final client = Client();
  final baseUrlScheme = 'https://';
  final baseUrlName = 'sentry.io';
  final baseUrlPath = '/api/0';

  Future<Response> organizations() async {
    return client.get('${_baseUrl()}/organizations/?member=1',
        headers: _defaultHeader()
    );
  }

  Future<Response> projects(String slug) async {
    return client.get('${_baseUrl()}/organizations/$slug/projects/',
        headers: _defaultHeader()
    );
  }

  Future<Response> releases(String projectId, {int perPage = 25, int health = 1, int flatten = 0, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'perPage': '$perPage',
      'health': '$health',
      'flatten': '$flatten',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    return client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$projectId/releases/', queryParameters),
        headers: _defaultHeader()
    );
  }

  Future<Response> release(String projectId, String releaseId, {int health = 1, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'health': '$health',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    return client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$projectId/releases/$releaseId/', queryParameters),
        headers: _defaultHeader()
    );
  }

  void close() {
    client.close();
  }

  // Helper

  String _baseUrl() {
    return '$baseUrlScheme$baseUrlName$baseUrlPath';
  }

  Map<String, String> _defaultHeader() {
    return {'Cookie': session.toString()};
  }
}